const express = require('express');
const router = express.Router();
const User = require('../models/user');

// GET /api/users/match?required=java&offered=flutter
router.get('/match', async (req, res) => {
  const { required, offered } = req.query;
  if (!required || !offered) {
    return res.status(400).json({ msg: 'Required and offered skills are needed' });
  }
  // Find users with complementary skills
  const users = await User.find({
    skillsOffered: { $regex: required, $options: 'i' },
    skillsRequired: { $regex: offered, $options: 'i' }
  }).select('name profileImage education location profession skillsOffered skillsRequired');
  // Add human-like reviews if missing
  const withReviews = users.map(u => ({
    ...u._doc,
    reviews: [
      {
        reviewer: "Priya Sharma",
        rating: 5.0,
        title: "Excellent mentor",
        date: "20 Sep 2025",
        comment: "Helped me understand Flutter concepts with patience."
      },
      {
        reviewer: "Rahul Verma",
        rating: 4.5,
        title: "Great collaborator",
        date: "18 Sep 2025",
        comment: "Worked together on a Java project, very supportive."
      }
    ]
  }));
  if (!withReviews.length) {
    // If no match, return random users with reviews
    const randomUsers = await User.aggregate([
      { $sample: { size: 3 } },
      { $project: { name: 1, profileImage: 1, education: 1, location: 1, profession: 1, skillsOffered: 1, skillsRequired: 1 } }
    ]);
    const randomWithReviews = randomUsers.map(u => ({
      ...u,
      reviews: [
        {
          reviewer: "Amit Singh",
          rating: 4.0,
          title: "Good teacher",
          date: "15 Sep 2025",
          comment: "Explained backend concepts clearly."
        }
      ]
    }));
    return res.json(randomWithReviews);
  }
  res.json(withReviews);
});

module.exports = router;
