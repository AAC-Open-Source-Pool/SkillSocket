const express = require('express');
const http = require('http');
const socketIo=require('socket.io');
const PostRoutes = require('./routes/PostRoutes.js');
const authRoutes = require('./routes/authRoutes.js');
const userUpdateRoutes = require('./routes/profileupdate.js');  
const chat = require('./routes/chatRoutes.js'); // AI chatbot route
const messageRoutes = require('./routes/messageRoutes.js'); // Message routes
const mongoose = require('mongoose');
const cors = require('cors');
const Message = require('./models/message.js'); // Import the Message model
const { JsonWebTokenError } = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io=socketIo(server,{
  cors:{
    origin:'*',
    methods:['GET', 'POST']
  }
});

app.use(cors());
app.use(express.json());
app.use('/api/posts', PostRoutes);
// Basic health check route
app.get('/', (req, res) => {
  res.status(200).json({ message: 'Backend server is running!', status: 'OK' });
});

// Register user update routes
app.use('/api/user', userUpdateRoutes);

// Register auth routes  
app.use('/api/auth', authRoutes);

// Register chatbot routes
app.use('/api/chat', chat);

// Register message routes
app.use('/api/messages', messageRoutes);

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb+srv://prashanth:prashanth@cluster0.5jyjzzh.mongodb.net/barter';
mongoose.connect(MONGODB_URI)
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error("MongoDB connection error:", err));

const onlineUsers = new Map();

io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);
  
  // User joins room
  socket.on('joinRoom', (userId) => {
    onlineUsers.set(userId, socket.id);
    socket.join(userId);
    console.log(`User ${userId} connected with socket ${socket.id}`);
  });

  // Handle typing indicators
  socket.on('typing', ({ from, to }) => {
    if (onlineUsers.has(to)) {
      io.to(to).emit('typing', { from });
    }
  });

  socket.on('stopTyping', ({ from, to }) => {
    if (onlineUsers.has(to)) {
      io.to(to).emit('stopTyping', { from });
    }
  });

  // Handle sending messages
  socket.on('sendMessage', async ({ from, to, content }) => {
    try {
      const newMsg = await Message.create({
        from,
        to,
        content,
        seen: false
      });
      
      // Populate the message with user details
      const populatedMsg = await Message.findById(newMsg._id)
        .populate('from', 'name email')
        .populate('to', 'name email');

      // Send message to recipient
      io.to(to).emit('receiveMessage', populatedMsg);
      
      // Don't send back to sender to prevent duplicates
      // Instead, emit delivery confirmation
      if (onlineUsers.has(to)) {
        // User is online, message delivered immediately
        io.to(from).emit('messageDelivered', { messageId: newMsg._id });
        
        // After a short delay, mark as read (simulating user seeing the message)
        setTimeout(() => {
          io.to(from).emit('messageRead', { messageId: newMsg._id });
        }, 2000);
      }
    } catch (err) {
      console.error("Error sending message:", err);
    }
  });

  // Handle marking messages as seen
  socket.on('markAsSeen', async ({ from, to }) => {
    try {
      await Message.updateMany(
        { from, to, seen: false },
        { $set: { seen: true } }
      );
      if (onlineUsers.has(from)) {
        io.to(from).emit('messagesSeen', { by: to });
      }
    } catch (err) {
      console.error("Error marking messages as seen:", err);
    }
  });

  // Handle user disconnection
  socket.on('disconnect', () => {
    onlineUsers.forEach((socketId, userId) => {
      if (socketId === socket.id) {
        onlineUsers.delete(userId);
        console.log(`User ${userId} disconnected`);
      }
    });
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});