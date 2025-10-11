# Todo Backend Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Flutter App                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    lib/home.dart                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  _MyHomePageState                                   │  │  │
│  │  │  - _todos: List<Map>                                │  │  │
│  │  │  - _loadingTodos: bool                              │  │  │
│  │  │                                                      │  │  │
│  │  │  Methods:                                           │  │  │
│  │  │  • initState() → _loadTodos()                       │  │  │
│  │  │  • onDaySelected() → _loadTodos()                   │  │  │
│  │  │  • onAdd() → TodoService.createTodo()               │  │  │
│  │  │  • onToggle() → TodoService.updateTodo()            │  │  │
│  │  │  • onDelete() → TodoService.deleteTodo()            │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              lib/services/todo_service.dart               │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Static Methods:                                    │  │  │
│  │  │  • getTodos(date) → GET /api/todos?date=...        │  │  │
│  │  │  • createTodo(date, task) → POST /api/todos        │  │  │
│  │  │  • updateTodo(id, {done}) → PATCH /api/todos/:id   │  │  │
│  │  │  • deleteTodo(id) → DELETE /api/todos/:id          │  │  │
│  │  │                                                      │  │  │
│  │  │  Helper Methods:                                    │  │  │
│  │  │  • _getToken() → SharedPreferences                 │  │  │
│  │  │  • _getHeaders() → Add JWT to Authorization        │  │  │
│  │  │  • _formatDate() → YYYY-MM-DD                       │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓ HTTPS
                              ↓ Authorization: Bearer TOKEN
┌─────────────────────────────────────────────────────────────────┐
│                    Render (Cloud Platform)                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              lib/backend/server.js                        │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Express App                                        │  │  │
│  │  │  • CORS enabled                                     │  │  │
│  │  │  • JSON body parser                                 │  │  │
│  │  │  • Routes registered:                               │  │  │
│  │  │    - /api/todos → todoRoutes                        │  │  │
│  │  │    - /api/auth → authRoutes                         │  │  │
│  │  │    - /api/posts → PostRoutes                        │  │  │
│  │  │    - ... (other routes)                             │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │           lib/backend/routes/todoRoutes.js                │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Middleware: verifyToken (JWT validation)          │  │  │
│  │  │                                                      │  │  │
│  │  │  Endpoints:                                         │  │  │
│  │  │  • GET    /api/todos?date=YYYY-MM-DD               │  │  │
│  │  │  • POST   /api/todos                                │  │  │
│  │  │  • PATCH  /api/todos/:id                            │  │  │
│  │  │  • DELETE /api/todos/:id                            │  │  │
│  │  │                                                      │  │  │
│  │  │  Each route:                                        │  │  │
│  │  │  1. Validates JWT token                             │  │  │
│  │  │  2. Extracts user ID from token                     │  │  │
│  │  │  3. Queries/updates MongoDB                         │  │  │
│  │  │  4. Returns JSON response                           │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │        lib/backend/middlewares/verifyToken.js             │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  1. Extract token from Authorization header        │  │  │
│  │  │  2. Verify token with JWT_SECRET                    │  │  │
│  │  │  3. Decode user info (userId, email)                │  │  │
│  │  │  4. Attach to req.user                              │  │  │
│  │  │  5. Call next() or return 401                       │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓ Mongoose ODM
┌─────────────────────────────────────────────────────────────────┐
│                    MongoDB Atlas (Cloud Database)                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                  Collection: todos                        │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Document Schema (lib/backend/models/Todo.js):     │  │  │
│  │  │  {                                                  │  │  │
│  │  │    _id: ObjectId,                                   │  │  │
│  │  │    user: ObjectId (ref: User),  ← indexed          │  │  │
│  │  │    date: Date,                  ← indexed          │  │  │
│  │  │    task: String,                                    │  │  │
│  │  │    done: Boolean,                                   │  │  │
│  │  │    createdAt: Date,                                 │  │  │
│  │  │    updatedAt: Date                                  │  │  │
│  │  │  }                                                  │  │  │
│  │  │                                                      │  │  │
│  │  │  Indexes:                                           │  │  │
│  │  │  • { user: 1, date: 1 } - Fast date queries        │  │  │
│  │  │  • { user: 1 } - User-level queries                │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Request Flow Example: Adding a Todo

```
┌──────────┐
│  User    │
│  Types   │  "Buy milk"
│  Task    │
└────┬─────┘
     │ Clicks checkmark
     ↓
┌────────────────────────────────────────────────────────────┐
│ Flutter: home.dart                                          │
│ onAdd() {                                                   │
│   final newTodo = await TodoService.createTodo(            │
│     dateKey,                                                │
│     _todoController.text                                    │
│   );                                                        │
│   setState(() => _todos.add(newTodo));                      │
│ }                                                           │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓ HTTP POST
     │ URL: https://skillsocket-backend.onrender.com/api/todos
     │ Headers: { Authorization: "Bearer eyJhbGc..." }
     │ Body: { date: "2025-10-11", task: "Buy milk" }
     │
┌────┴───────────────────────────────────────────────────────┐
│ Backend: server.js                                          │
│ app.use('/api/todos', todoRoutes)                           │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓
┌────┴───────────────────────────────────────────────────────┐
│ Middleware: verifyToken.js                                  │
│ 1. Extract token from header                                │
│ 2. jwt.verify(token, JWT_SECRET)                            │
│ 3. req.user = { userId: "...", email: "..." }              │
│ 4. next()                                                   │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓
┌────┴───────────────────────────────────────────────────────┐
│ Route: todoRoutes.js                                        │
│ router.post('/', verifyToken, async (req, res) => {        │
│   const { date, task } = req.body;                          │
│   const todo = await Todo.create({                          │
│     user: req.user.userId,  ← From JWT token               │
│     date: normalizeDate(date),                              │
│     task,                                                   │
│     done: false                                             │
│   });                                                       │
│   res.status(201).json(todo);                               │
│ });                                                         │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓ Mongoose
     │ Todo.create({ user, date, task, done })
     │
┌────┴───────────────────────────────────────────────────────┐
│ MongoDB: todos collection                                   │
│ INSERT {                                                    │
│   _id: ObjectId("..."),                                     │
│   user: ObjectId("507f191e810c19729de860ea"),              │
│   date: ISODate("2025-10-11T00:00:00.000Z"),               │
│   task: "Buy milk",                                         │
│   done: false,                                              │
│   createdAt: ISODate("2025-10-11T11:20:30.000Z"),          │
│   updatedAt: ISODate("2025-10-11T11:20:30.000Z")           │
│ }                                                           │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓ Response
     │ Status: 201 Created
     │ Body: { _id: "...", task: "Buy milk", done: false, ... }
     │
┌────┴───────────────────────────────────────────────────────┐
│ Flutter: TodoService.createTodo()                           │
│ return {                                                    │
│   '_id': data['_id'],                                       │
│   'task': data['task'],                                     │
│   'done': data['done'],                                     │
│   'date': data['date']                                      │
│ };                                                          │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓
┌────┴───────────────────────────────────────────────────────┐
│ Flutter: home.dart                                          │
│ setState(() {                                               │
│   _todos.add(newTodo);  ← UI updates                        │
│   _todoController.clear();                                  │
│ });                                                         │
└────┬───────────────────────────────────────────────────────┘
     │
     ↓
┌────┴─────┐
│  User    │
│  Sees    │  "Buy milk" appears in list
│  Todo    │
└──────────┘
```

## Security Flow

```
┌─────────────┐
│ User Login  │
└──────┬──────┘
       │ POST /api/auth/login
       │ { email, password }
       ↓
┌──────────────────────────┐
│ Backend: authRoutes.js   │
│ 1. Verify credentials    │
│ 2. Generate JWT token    │
│ 3. Return token          │
└──────┬───────────────────┘
       │ { token: "eyJhbGc..." }
       ↓
┌──────────────────────────┐
│ Flutter: SharedPrefs     │
│ Save token locally       │
└──────┬───────────────────┘
       │
       │ Every API request includes:
       │ Authorization: Bearer TOKEN
       ↓
┌──────────────────────────┐
│ Backend: verifyToken     │
│ 1. Extract token         │
│ 2. Verify signature      │
│ 3. Check expiration      │
│ 4. Extract user ID       │
│ 5. Attach to req.user    │
└──────┬───────────────────┘
       │
       ↓ Only if valid
┌──────────────────────────┐
│ Route Handler            │
│ Access req.user.userId   │
│ Query user's data only   │
└──────────────────────────┘
```

## Data Isolation

```
MongoDB Collection: todos
┌─────────────────────────────────────────────────────────┐
│ User A's Todos                                           │
│ { user: "A", date: "2025-10-11", task: "Task 1" }      │
│ { user: "A", date: "2025-10-11", task: "Task 2" }      │
│ { user: "A", date: "2025-10-12", task: "Task 3" }      │
├─────────────────────────────────────────────────────────┤
│ User B's Todos                                           │
│ { user: "B", date: "2025-10-11", task: "Different" }   │
│ { user: "B", date: "2025-10-11", task: "Tasks" }       │
└─────────────────────────────────────────────────────────┘

Query: GET /api/todos?date=2025-10-11
With User A's token → Returns only User A's todos
With User B's token → Returns only User B's todos

Backend enforces:
Todo.find({ user: req.user.userId, date: ... })
                    ↑
                    Always scoped to authenticated user
```

## Deployment Architecture

```
┌──────────────┐
│  Developer   │
│   Machine    │
└──────┬───────┘
       │ git push origin main
       ↓
┌──────────────────────────┐
│  GitHub Repository       │
│  25AACR02                │
└──────┬───────────────────┘
       │ Webhook trigger
       ↓
┌──────────────────────────┐
│  Render Platform         │
│  1. Pull latest code     │
│  2. npm install          │
│  3. node server.js       │
│  4. Health check         │
│  5. Route traffic        │
└──────┬───────────────────┘
       │ HTTPS
       ↓
┌──────────────────────────┐
│  Public URL              │
│  skillsocket-backend     │
│  .onrender.com           │
└──────────────────────────┘
```

## Environment Variables Flow

```
Render Dashboard
└─ Environment Variables
   ├─ MONGODB_URI → Connection to MongoDB Atlas
   ├─ JWT_SECRET → Token signing key
   ├─ PORT → 3000 (default)
   └─ NODE_ENV → production

        ↓ Injected at runtime

   server.js reads:
   - process.env.MONGODB_URI
   - process.env.JWT_SECRET
   - process.env.PORT

        ↓ Used by

   - mongoose.connect(MONGODB_URI)
   - jwt.verify(token, JWT_SECRET)
   - server.listen(PORT)
```

## File Structure

```
25AACR02/
├── lib/
│   ├── backend/
│   │   ├── models/
│   │   │   ├── Todo.js          ← NEW: MongoDB schema
│   │   │   ├── User.js
│   │   │   └── ...
│   │   ├── routes/
│   │   │   ├── todoRoutes.js    ← NEW: CRUD endpoints
│   │   │   ├── authRoutes.js
│   │   │   └── ...
│   │   ├── middlewares/
│   │   │   └── verifyToken.js   ← JWT validation
│   │   ├── server.js            ← MODIFIED: Register routes
│   │   └── package.json
│   ├── services/
│   │   ├── todo_service.dart    ← NEW: API client
│   │   ├── post_service.dart
│   │   └── ...
│   └── home.dart                ← MODIFIED: Use API
├── TODO_BACKEND_README.md       ← NEW: Documentation
├── DEPLOYMENT_CHECKLIST.md      ← NEW: Testing guide
├── TODO_INTEGRATION_SUMMARY.md  ← NEW: Overview
├── QUICK_START.md               ← NEW: Quick deploy
└── TODO_ARCHITECTURE.md         ← NEW: This file
```

---

This architecture provides:
- ✅ **Separation of Concerns**: UI, API, Database layers
- ✅ **Security**: JWT authentication, user isolation
- ✅ **Scalability**: Indexed queries, RESTful design
- ✅ **Maintainability**: Clear structure, documented
- ✅ **Reliability**: Error handling, validation
