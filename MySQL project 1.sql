USE ig_clone;
-- 1]Create an ER diagram or draw a schema for the given database.


-- 2]We want to reward the user who has been around the longest, Find the 5 oldest users
SELECT * FROM users;

SELECT id, username, created_at FROM users 
order by created_at
limit 5;

-- 3]To understand when to run the ad campaign, figure out the day of the week most users register on?

SELECT * FROM users;

WITH CTE AS
(SELECT id, username,created_at,
	CASE 
		WHEN weekday(created_at)= '0' THEN 'MONDAY'
		WHEN weekday(created_at)= '1' THEN 'TUESDAY'
		WHEN weekday(created_at)= '2' THEN 'WEDNESDAY'
		WHEN weekday(created_at)= '3' THEN 'THURSDAY'
		WHEN weekday(created_at)= '4' THEN 'FRIDAY'
		WHEN weekday(created_at)= '5' THEN 'SATURDAY'
		WHEN weekday(created_at)= '6' THEN 'SUNDAY'
	END AS day_name
FROM users)

SELECT day_name, count(day_name) as no_of_days from CTE
group by day_name
order by no_of_days desc
;

-- 4]To target inactive users in an email ad campaign, find the users who have never posted a photo.
 
SELECT * FROM users;
SELECT * FROM photos;

SELECT id, username FROM users 
WHERE id not in (select user_id from photos)
ORDER BY id ;


-- 5]Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

SELECT * FROM LIKES;
SELECT * FROM USERS;
SELECT * FROM photos;

SELECT U.USERNAME, L.PHOTO_ID, COUNT(L.USER_ID)AS NO_OF_LIKES
FROM LIKES L JOIN PHOTOS P ON L.PHOTO_ID=P.ID
JOIN USERS U ON U.ID=P.USER_ID
GROUP BY PHOTO_ID
ORDER BY NO_OF_LIKES DESC;

-- 6]The investors want to know how many times does the average user post.

SELECT * FROM USERS;
SELECT  * FROM PHOTOS;

CREATE VIEW AVG_USER_POST AS
SELECT U.USERNAME, P.USER_ID, COUNT(P.ID)AS NO_OF_POST
FROM USERS U INNER JOIN PHOTOS P ON P.ID=U.ID
GROUP BY P.USER_ID
ORDER BY NO_OF_POST DESC;
SELECT AVG(NO_OF_POST) FROM AVG_USER_POST;



-- 7]A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

SELECT * FROM TAGS;
SELECT * FROM PHOTO_TAGS;

SELECT T.ID,T.TAG_NAME, COUNT(PT.PHOTO_ID) AS NO_OF_HASHTAGS
FROM TAGS T INNER JOIN PHOTO_TAGS PT ON PT.TAG_ID=T.ID
GROUP BY PT.TAG_ID
ORDER BY NO_OF_HASHTAGS DESC
LIMIT 5;


-- 8]To find out if there are bots, find users who have liked every single photo on the site

SELECT * FROM LIKES;
SELECT * FROM USERS;
SELECT * FROM PHOTOS;

SELECT L.USER_ID,COUNT(L.PHOTO_ID)AS LIKED_PIC 
FROM USERS U JOIN LIKES L ON L.USER_ID=U.ID
GROUP BY USER_ID
HAVING LIKED_PIC =(SELECT COUNT(ID) FROM PHOTOS) -- HERE WE FIND TOTAL NO OF PHOTOS ARE UPLOADED
ORDER BY USER_ID;

-- 9]To know who the celebrities are, find users who have never commented on a photo

SELECT * FROM USERS;
SELECT * FROM COMMENTS;

SELECT ID, USERNAME AS CELEBRITY FROM USERS WHERE ID NOT IN(SELECT USER_ID FROM COMMENTS );

-- 10]Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.

CREATE VIEW COMMON_PEPOLE AS
(SELECT USER_ID,COUNT(PHOTO_ID)AS COMMENTED_PHOTOS FROM COMMENTS
GROUP BY USER_ID
HAVING COMMENTED_PHOTOS =(SELECT COUNT(ID) FROM PHOTOS) -- HERE WE FIND TOTAL NO OF PHOTOS ARE UPLOADED
);

SELECT ID, USERNAME AS COMMON_PEOPLES FROM USERS WHERE ID IN(SELECT USER_ID FROM COMMON_PEPOLE)
UNION
SELECT ID, USERNAME AS CELEBRITY FROM USERS WHERE ID NOT IN(SELECT USER_ID FROM COMMENTS );
