-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

WITH cnt_users AS (
SELECT 
      user_id,
      user_name,
      sent_at::DATE AS day_sent,
      COUNT(message_id) as cn_count
FROM npn_users n
INNER JOIN npn_messages s
ON n.user_id = s.sender_id
GROUP BY user_id, user_name, day_sent
),
rank AS
(
SELECT 
      user_name,
      day_sent,
      cn_count,
      RANK () OVER (PARTITION BY day_sent ORDER BY cn_count DESC) AS rn
FROM cnt_users)
  
SELECT 
      user_name,
      day_sent,
      cn_count
FROM rank
  WHERE rn =1 
ORDER BY day_sent DESC
