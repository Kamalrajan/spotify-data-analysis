use spotify_data_analysis;

select * from spotify_tracks;




CREATE TABLE IF NOT EXISTS spotify_tracks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    track_name VARCHAR(255),
    artist VARCHAR(255),
    album VARCHAR(255),
    popularity INT,
    duration_minutes FLOAT
) SELECT * FROM
    spotify_tracks;
    
    -- delete the duplicates valuves
WITH ranked AS (
    SELECT id, track_name, artist, album, popularity, duration_minutes,
           ROW_NUMBER() OVER (PARTITION BY track_name, artist, album ORDER BY id) AS row_num
    FROM spotify_tracks
)
DELETE FROM spotify_tracks
WHERE id IN (SELECT id FROM ranked WHERE row_num > 1);

-- now reset the primary id 

ALTER TABLE spotify_tracks DROP COLUMN id;
ALTER TABLE spotify_tracks ADD COLUMN id INT PRIMARY KEY AUTO_INCREMENT FIRST;

SET @new_id = 0;

UPDATE spotify_tracks
SET id = (@new_id := @new_id + 1)
ORDER BY track_name;



SELECT track_name, artist, album, popularity
FROM spotify_tracks
ORDER BY popularity DESC
LIMIT 1;


SELECT AVG(popularity) AS average_popularity
FROM spotify_tracks;


SELECT track_name, artist, duration_minutes
FROM spotify_tracks
WHERE duration_minutes > 4.0;

SELECT 
    CASE 
        WHEN popularity >= 80 THEN 'Very Popular'
        WHEN popularity >= 50 THEN 'Popular'
        ELSE 'Less Popular'
    END AS popularity_range,
    COUNT(*) AS track_count
FROM spotify_tracks
GROUP BY popularity_range;



