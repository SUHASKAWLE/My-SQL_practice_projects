use moviedb;

-- Q1) Query for the "ANNIE HALL" movie actor's role and name
select *from actors;
select * from movie_cast;
select * from movie;

-- by using where clause
SELECT act_fname, act_lname, role 
FROM actors a, movie_cast m, movie d
WHERE a.act_id = m.act_id AND m.mov_id = d.mov_id AND d.mov_title = "ANNIE HALL";
 
 -- by using join
 SELECT act_fname,act_lname, role
 FROM actors a INNER JOIN movie_cast m ON a.act_id = m.act_id
 INNER JOIN movie d ON m.mov_id = d.mov_id AND d.mov_title = "ANNIE HALL";
 
 -- RESULT = DONE
 
 
 -- Q2) director who direct the movie EYES WIDE SHUT
 
 select *from director;
 select * from movie;
 select *from movie_direction;
 
 SELECT dir_fname, dir_lname, mov_title
 FROM movie m INNER JOIN movie_direction md ON m.mov_id = md.mov_id
 INNER JOIN director d ON d.dir_id=md.dir_id AND m.mov_title = "EYES WIDE SHUT";
 
 -- RESULT = DONE
 
 -- Q3) SEAN MAGUIRE's movie and his director

 select *from director;
 select *from movie_direction;
 SELECT *FROM MOVIE_CAST;
 SELECT *FROM MOVIE;
 
  SELECT dir_fname, dir_lname, mov_title ,role
 FROM movie m INNER JOIN movie_direction md ON m.mov_id = md.mov_id
 INNER JOIN director d ON d.dir_id=md.dir_id 
 INNER JOIN movie_cast mc ON mc.mov_id = m.mov_id
 AND mc.role = "SEAN MAGUIRE";
 
 -- RESULT = DONE
 
 
 -- Q4) actors who not acted in any movie from 1990 to 2000
 
 select *from actors;
 select *from movie;
 select *from movie_cast;
 
 SELECT act_fname, act_lname, mov_title, mov_year
 FROM actors a INNER JOIN movie_cast mc ON a.act_id = mc.act_id 
 INNER JOIN movie m ON m.mov_id = mc.mov_id
 WHERE m.mov_year NOT BETWEEN '1990' AND '2000' ;
 
 -- RESULT = DONE
 
 -- Q5) QUERY FOR NUMBER OF GENRES FOR DIRECTOR
 
 select *from director;
 select *from genres;
 select *from movie_direction;
 select *from movie_genres;
 
 SELECT dir_fname, dir_lname, gen_title, COUNT(*) AS no_of_genres
 FROM director d INNER JOIN movie_direction md ON d.dir_id = md.dir_id
 INNER JOIN movie_genres mg ON mg.mov_id = md.mov_id
 INNER JOIN genres g ON g.gen_id = mg.gen_id
 GROUP BY dir_fname, dir_lname, gen_title HAVING COUNT(*)
 ORDER BY dir_fname, dir_lname asc;

-- RESULT = DONE