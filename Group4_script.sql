CREATE SCHEMA airbnb;



--------------------------------- IMPORT DATA ---------------------------------

---------- CALENDAR ----------
CREATE TABLE airbnb.calendar (
	date date NOT NULL,
	listing_id int NOT NULL,          
	available BOOLEAN ,               
	price_$ VARCHAR(255),              
	adjusted_price_$ VARCHAR(255),    
	minimum_nights smallint,          
	maximum_nights int,               
	CONSTRAINT pk_calendar PRIMARY KEY (listing_id, date) --- set primary key on lisitngs ID 
);

COPY airbnb.calendar (listing_id,date,available,price_$,adjusted_price_$,minimum_nights,maximum_nights)  --- import the data from computer 
FROM '/home/hungnguyen/PythonWorks/SQL/data/calendar.csv' DELIMITER E',' CSV HEADER;      --- PATH to the csv file need to change 


--- Alter datatype to int for price 
ALTER TABLE airbnb.calendar ALTER COLUMN price_$ TYPE int USING (TRANSLATE(price_$,',$','')::float::int);                   --- change price from VARCHAR to INT
ALTER TABLE airbnb.calendar ALTER COLUMN adjusted_price_$ TYPE int USING (TRANSLATE(adjusted_price_$,',$','')::float::int); --- change adjusted_price from VARCHAR to INT


---------- LISTINGS ----------
CREATE TABLE airbnb.listings (             --- create the lisitng table 
	id  int,
	listing_url  VARCHAR(50),
	scrape_id bigint,
	last_scraped  date,
	name  VARCHAR(255),
	description  VARCHAR(1000),
	neighborhood_overview  VARCHAR(1000),
	picture_url  VARCHAR(255),
	host_id  int,
	host_url  VARCHAR(255),
	host_name  VARCHAR(50),
	host_since  date,
	host_location  VARCHAR(255),
	host_about  VARCHAR,
	host_response_time  VARCHAR(18),
	host_response_rate  VARCHAR(4),
	host_acceptance_rate  VARCHAR(4),
	host_is_superhost  BOOLEAN,
	host_thumbnail_url  VARCHAR(255),
	host_picture_url  VARCHAR(255),
	host_neighbourhood  VARCHAR(50),
	host_listings_count  smallint,
	host_total_listings_count  smallint,
	host_verifications  VARCHAR,
	host_has_profile_pic  BOOLEAN,
	host_identity_verified  BOOLEAN,
	neighbourhood  VARCHAR(255),
	neighbourhood_cleansed  TSVECTOR,
	neighbourhood_group_cleansed  VARCHAR(255),
	latitude  FLOAT,
	longitude  FLOAT,
	property_type  VARCHAR(255),
	room_type  VARCHAR(255),
	accommodates  smallint,
	bathrooms  smallint,
	bathrooms_text  VARCHAR(255),
	bedrooms  smallint,
	beds  smallint,
	amenities  VARCHAR,
	price_$  VARCHAR,
	minimum_nights  smallint,
	maximum_nights  int,
	minimum_minimum_nights  smallint,
	maximum_minimum_nights  smallint,
	minimum_maximum_nights  int,
	maximum_maximum_nights  int,
	minimum_nights_avg_ntm  FLOAT,
	maximum_nights_avg_ntm  FLOAT,
	calendar_updated  VARCHAR(255),
	has_availability  BOOLEAN,
	availability_30  smallint,
	availability_60  smallint,
	availability_90  smallint,
	availability_365  smallint,
	calendar_last_scraped  date,
	number_of_reviews  smallint,
	number_of_reviews_ltm  smallint,
	number_of_reviews_l30d  smallint,
	first_review  date,
	last_review  date,
	review_scores_rating  smallint,
	review_scores_accuracy  smallint,
	review_scores_cleanliness  smallint,
	review_scores_checkin  smallint,
	review_scores_communication  smallint,
	review_scores_location  smallint,
	review_scores_value  smallint,
	license  VARCHAR(255),
	instant_bookable  BOOLEAN,
	calculated_host_listings_count  smallint,
	calculated_host_listings_count_entire_homes  smallint,
	calculated_host_listings_count_private_rooms  smallint,
	calculated_host_listings_count_shared_rooms  smallint,
	reviews_per_month  FLOAT,
	CONSTRAINT pk_listings PRIMARY KEY(id)                  --- set the primary key to id of listings
);

--- import cvs into the table, PATH need to be changed
COPY airbnb.listings (id,listing_url,scrape_id,last_scraped,name,description,neighborhood_overview,picture_url,host_id,host_url,host_name,host_since,host_location,host_about,host_response_time,host_response_rate,host_acceptance_rate,host_is_superhost,host_thumbnail_url,host_picture_url,host_neighbourhood,host_listings_count,host_total_listings_count,host_verifications,host_has_profile_pic,host_identity_verified,neighbourhood,neighbourhood_cleansed,neighbourhood_group_cleansed,latitude,longitude,property_type,room_type,accommodates,bathrooms,bathrooms_text,bedrooms,beds,amenities,price_$,minimum_nights,maximum_nights,minimum_minimum_nights,maximum_minimum_nights,minimum_maximum_nights,maximum_maximum_nights,minimum_nights_avg_ntm,maximum_nights_avg_ntm,calendar_updated,has_availability,availability_30,availability_60,availability_90,availability_365,calendar_last_scraped,number_of_reviews,number_of_reviews_ltm,number_of_reviews_l30d,first_review,last_review,review_scores_rating,review_scores_accuracy,review_scores_cleanliness,review_scores_checkin,review_scores_communication,review_scores_location,review_scores_value,license,instant_bookable,calculated_host_listings_count,calculated_host_listings_count_entire_homes,calculated_host_listings_count_private_rooms,calculated_host_listings_count_shared_rooms,reviews_per_month)
FROM '/home/hungnguyen/PythonWorks/SQL/data/listings.csv' DELIMITER E',' CSV HEADER; 

ALTER TABLE airbnb.listings ALTER COLUMN price_$ TYPE int USING (TRANSLATE(price_$,',$','')::float::int);  --- change price from VARCHAR to INT


---------- REVIEWS ----------
CREATE TABLE airbnb.reviews (     
	listing_id int,
	id bigint,
	date date,
	reviewer_id int, 
	reviewer_name VARCHAR(50),
	comments VARCHAR,
	CONSTRAINT pk_reviews PRIMARY KEY (id)       --- set the primary key to id of listings
);


--- import cvs into the table, PATH need to be changed
COPY airbnb.reviews (listing_id,id,date,reviewer_id,reviewer_name,comments)
FROM '/home/hungnguyen/PythonWorks/SQL/data/reviews.csv' DELIMITER ',' CSV HEADER;


--------------------------------- MANIPULATE LISTINGS ---------------------------------

----- CREATE DISTINCT listings_host table

CREATE TABLE airbnb.listings_host AS
SELECT DISTINCT
		host_id,
		host_url,
		host_name,
		host_since,
		host_location,
		host_about,
		host_response_time,
		host_response_rate,
		host_acceptance_rate,
		host_is_superhost,
		host_thumbnail_url,
		host_picture_url,
		host_neighbourhood,
		host_listings_count,
		host_total_listings_count,
		host_verifications,
		host_has_profile_pic,
		host_identity_verified,
		calculated_host_listings_count,
		calculated_host_listings_count_entire_homes,
		calculated_host_listings_count_shared_rooms
		FROM airbnb.listings;
				
	
ALTER TABLE airbnb.listings_host ADD PRIMARY KEY(host_id);   --- set the primary key to host id




----- CREATE listing_scrape table 
CREATE TABLE airbnb.listings_scrape AS
SELECT id,
       last_scraped,
	   availability_30,
	   availability_60,
	   availability_90,
	   availability_365,
	   number_of_reviews,
	   number_of_reviews_ltm,
	   number_of_reviews_l30d,
	   first_review,
	   last_review,
	   review_scores_rating,
	   review_scores_accuracy,
	   review_scores_cleanliness,
	   review_scores_checkin,
	   review_scores_communication,
	   review_scores_location,
	   review_scores_value,
	   instant_bookable
	   FROM airbnb.listings;
	   
ALTER TABLE airbnb.listings_scrape ADD PRIMARY KEY(id);    --- set the primary key to id of listings_scrape



----- CREATE TABLE listings_ameninities

CREATE TABLE airbnb.listings_amenities AS 
WITH to_remove AS (
SELECT id,
	   UNNEST(string_to_array(amenities,'", "')) AS amenities   --- convert strings to arrays and spearate in each column paried with the listing id
	FROM airbnb.listings
	WHERE amenities IS NOT NULL
	), to_remove2 AS (
SELECT id,
	   TRIM(amenities,']"["') amenities
	FROM to_remove
	), to_remove3 AS (
SELECT DISTINCT * FROM to_remove2)
SELECT *
	FROM to_remove3;

ALTER TABLE airbnb.listings_amenities ADD PRIMARY KEY(id,amenities);  --- set the primary key to id of airbnb.listings_amenities

------ Create table host_vertify_by


CREATE TABLE airbnb.listings_host_verify AS 
WITH v1 AS (
SELECT host_id,
	   UNNEST(string_to_array(host_verifications,',')) AS host_verifications   --- convert strings to arrays and spearate in each column paried with the listing id
	FROM airbnb.listings_host                                                             
	WHERE host_identity_verified = true AND host_verifications IS NOT NULL                                                  
	), v2 AS (                                                                            
SELECT host_id,                                                                           
	   TRIM(TRANSLATE(host_verifications,'['']','')) host_verifications
	FROM v1
	), v3 AS (
SELECT DISTINCT * FROM v2)
SELECT *
	FROM v3;


--------------------------------- CREATE ID FOR ROOM TYPE, PROPERTY TYPE, AMENITIES AND HOST_VERTIFY ---------------------------------

--- id table----

--- CREATE room type id
CREATE TABLE airbnb.room_type (id SERIAL primary key, 
				  room_type VARCHAR(255) NOT NULL
				  ); 

INSERT INTO airbnb.room_type ( room_type) 
SELECT DISTINCT room_type AS type1 
FROM airbnb.listings GROUP BY type1;


--- CREATE property type id
CREATE TABLE airbnb.property_type (
	id SERIAL PRIMARY KEY,
	listing_type VARCHAR (255) NOT NULL
); 

INSERT INTO airbnb.property_type(listing_type) 
SELECT DISTINCT property_type AS type2 
FROM airbnb.listings GROUP BY type2;



--- CREATE amenities type id
CREATE TABLE airbnb.amenities_type (
	id SERIAL PRIMARY KEY,
	amenities_type VARCHAR(255) NOT NULL
);

INSERT INTO airbnb.amenities_type (amenities_type)
SELECT DISTINCT amenities AS amenities_type
FROM airbnb.listings_amenities GROUP BY amenities_type;


--- CREATE host_verify_by id


CREATE TABLE airbnb.listings_host_verify_by (
	id SERIAL PRIMARY KEY,
	vertifications_type VARCHAR(255) NOT NULL
);


INSERT INTO airbnb.listings_host_verify_by (vertifications_type)
SELECT distinct airbnb.listings_host_verify.host_verifications as vertifications_type
FROM airbnb.listings_host_verify GROUP BY vertifications_type;



--- UPDATE room_type and property_type

--- UPDATE room type id
UPDATE airbnb.listings
SET room_type = airbnb.room_type.id
FROM airbnb.room_type
WHERE airbnb.listings.room_type = airbnb.room_type.room_type;


--- UPDATE property type id 
UPDATE airbnb.listings
SET property_type = airbnb.property_type.id
FROM airbnb.property_type
WHERE airbnb.listings.property_type = airbnb.property_type.listing_type;


--- UPDATE amenities type id 
UPDATE airbnb.listings_amenities 
SET amenities = airbnb.amenities_type.id
FROM airbnb.amenities_type
WHERE airbnb.listings_amenities.amenities = airbnb.amenities_type.amenities_type;

--- UPDATE verify type id 
UPDATE airbnb.listings_host_verify
SET host_verifications = airbnb.listings_host_verify_by.id
FROM airbnb.listings_host_verify_by
WHERE airbnb.listings_host_verify.host_verifications = airbnb.listings_host_verify_by.vertifications_type;


--- ALTER column to smallint for foreign key airbnb.amenities_type
ALTER TABLE airbnb.listings ALTER COLUMN room_type TYPE smallint USING (TRIM(room_type)::integer);

ALTER TABLE airbnb.listings ALTER COLUMN property_type TYPE smallint USING (TRIM(property_type)::integer);

ALTER TABLE airbnb.listings_amenities ALTER COLUMN amenities TYPE smallint USING (TRIM(amenities)::integer);

ALTER TABLE airbnb.listings_host_verify ALTER COLUMN host_verifications TYPE smallint USING (TRIM(host_verifications)::integer);

--------------------------------- DROP INFORMATION THAT EXISTS IN OTHER TABLES ---------------------------------
--- DROP FOR airbnb_listing_host
ALTER TABLE airbnb.listings 
DROP COLUMN host_url,
DROP COLUMN host_name,
DROP COLUMN host_since,
DROP COLUMN host_location,
DROP COLUMN host_about,
DROP COLUMN host_response_time,
DROP COLUMN host_response_rate,
DROP COLUMN host_acceptance_rate,
DROP COLUMN host_is_superhost,
DROP COLUMN host_thumbnail_url,
DROP COLUMN host_picture_url,
DROP COLUMN host_neighbourhood,
DROP COLUMN host_listings_count,
DROP COLUMN host_total_listings_count,
DROP COLUMN host_verifications,
DROP COLUMN host_has_profile_pic,
DROP COLUMN host_identity_verified,
DROP COLUMN calculated_host_listings_count,
DROP COLUMN calculated_host_listings_count_entire_homes,
DROP COLUMN calculated_host_listings_count_shared_rooms;

--- DROP FOR airbnb.listings_amenities
ALTER TABLE airbnb.listings
DROP COLUMN amenities;

--- DROP FOR airbnb.listings_scrape
ALTER TABLE airbnb.listings 
DROP COLUMN	scrape_id,
DROP COLUMN	last_scraped,
DROP COLUMN availability_30,
DROP COLUMN	    availability_60,
DROP COLUMN	   availability_90,
DROP COLUMN	   availability_365,
DROP COLUMN	   number_of_reviews,
DROP COLUMN	   number_of_reviews_ltm,
DROP COLUMN	   number_of_reviews_l30d,
DROP COLUMN	   first_review,
DROP COLUMN	   last_review,
DROP COLUMN	   review_scores_rating,
DROP COLUMN	   review_scores_accuracy,
DROP COLUMN	   review_scores_cleanliness,
DROP COLUMN	   review_scores_checkin,
DROP COLUMN	   review_scores_communication,
DROP COLUMN	   review_scores_location,
DROP COLUMN	   review_scores_value,
DROP COLUMN	   instant_bookable,
DROP COLUMN	   calendar_last_scraped;


--- DROP host_verification from lisitngs_host table 
ALTER TABLE airbnb.listings_host
DROP COLUMN host_verifications;


--- DROP minimum and maximum night from airbnb calendar table 
ALTER TABLE airbnb.calendar
DROP COLUMN minimum_nights,
DROP COLUMN maximum_nights;

--- all null values 
ALTER TABLE airbnb.listings
DROP COLUMN bathrooms,
DROP COLUMN neighbourhood_group_cleansed  ,
DROP COLUMN license,
DROP COLUMN calendar_updated
;


--------------------------------- FOREIGN KEY ---------------------------------

ALTER TABLE airbnb.calendar ADD CONSTRAINT listings
FOREIGN KEY(listing_id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_amenities ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings ADD CONSTRAINT host_id
FOREIGN KEY(host_id) REFERENCES airbnb.listings_host(host_id);

ALTER TABLE airbnb.reviews ADD CONSTRAINT listings
FOREIGN KEY(listing_id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_scrape ADD CONSTRAINT listings
FOREIGN KEY(id) REFERENCES airbnb.listings(id);

ALTER TABLE airbnb.listings_amenities ADD CONSTRAINT amenities_id
FOREIGN KEY(amenities) REFERENCES airbnb.amenities_type(id);


ALTER TABLE airbnb.listings ADD CONSTRAINT room_type
FOREIGN KEY(room_type) REFERENCES airbnb.room_type(id);

ALTER TABLE airbnb.listings ADD CONSTRAINT property_type 
FOREIGN KEY(property_type ) REFERENCES airbnb.property_type(id);

ALTER TABLE airbnb.listings_host_verify ADD CONSTRAINT verify_id
FOREIGN KEY(host_verifications) REFERENCES airbnb.listings_host_verify_by(id);



-------------------------CREATE INDEX---------------------------------
CREATE INDEX room_type_idx ON airbnb.listings USING btree (room_type);
CREATE INDEX property_type_idx ON airbnb.listings USING btree (property_type);
CREATE INDEX id_idx ON airbnb.listings USING btree (id);
CREATE INDEX neighbourhood_cleansed_idx ON airbnb.listings USING GIN (neighbourhood_cleansed);

CREATE INDEX property_type_id ON airbnb.property_type USING btree (id);
CREATE INDEX room_type_id ON airbnb.room_type USING btree (id);

CREATE INDEX listing_id_indx ON airbnb.calendar USING btree (listing_id);
CREATE INDEX date_id ON airbnb.calendar USING btree (data);


EXPLAIN ANALYZE
SELECT * FROM airbnb.listings
WHERE id = '6795';




--------------------------------- PART 2 -----------------------------------------------------------------------------------



---------------------- view 2-----------------------------------
CREATE VIEW view2 AS 
SELECT	l.neighbourhood_cleansed,
		c.date,
		SUM(available::int) AS available_for_book 
	FROM airbnb.calendar c
	INNER JOIN airbnb.listings l ON l.id = c.listing_id
	GROUP BY neighbourhood_cleansed, date
	ORDER BY neighbourhood_cleansed, date;

SELECT * FROM view2;


--- create view for sum of all_home, home_by_borough and home_by_roomtype
CREATE VIEW view_sum AS 
SELECT COUNT(DISTINCT id) AS total
FROM airbnb.listings;

CREATE VIEW view_sum_borough AS
SELECT 
neighbourhood_cleansed,
COUNT(neighbourhood_cleansed) AS total_borough
FROM airbnb.listings
GROUP BY neighbourhood_cleansed;


--- to show overall room available to book by month of that year 
--- as percentage of total amount of listings in that month of the year 

SELECT 
to_char(date, 'yyyy-mm') AS month_and_year, 
SUM(available_for_book) AS total_night, 
ROUND (SUM(available_for_book)*100/ (COUNT(DISTINCT date) * total),5) AS PERCENTAGE_night
FROM view2, view_sum
GROUP BY month_and_year,total
ORDER BY month_and_year;



--- to show trend of each neighbourhood's rooms available to book by month of that year
--- as percentage of total amount of listings in that month of the year in that borough

SELECT 
v2.neighbourhood_cleansed, 
to_char(date, 'yyyy-mm') AS month_and_year, 
SUM(v2.available_for_book) AS total_night,
ROUND (SUM(v2.available_for_book)*100/ (COUNT(DISTINCT date)* vb.total_borough),2) AS PERCENTAGE_night 
FROM view2 v2, view_sum_borough vb 
WHERE v2.neighbourhood_cleansed = vb.neighbourhood_cleansed
GROUP BY v2.neighbourhood_cleansed,vb.total_borough,month_and_year
ORDER BY v2.neighbourhood_cleansed, month_and_year;

	
--------------------------------	
--- CREATE GENERAL OVERVIEW ---

--- table contains (area, average_price, average_review, average_rating, average_rpm)

WITH to_remove1 AS(
SELECT COUNT(DISTINCT(id)) AS unique_id
	FROM airbnb.listings
)SELECT	
	l.neighbourhood_cleansed, 
	ROUND (AVG(l.price_$),3) AS average_price, 
	ROUND(AVG(ls.number_of_reviews),3) AS average_reviews, 
	ROUND (AVG(ls.review_scores_rating),3) AS average_rating, 
	AVG(l.reviews_per_month) AS average_reviewpermonth, 
	ROUND((COUNT(*)::numeric)*100 / (SELECT unique_id FROM to_remove1),2) AS percentage_total_listing
	FROM view_sum vs ,airbnb.listings l 
	INNER JOIN 
	airbnb.listings_scrape ls ON ls.id = l.id 
	GROUP BY l.neighbourhood_cleansed
	ORDER BY percentage_total_listing DESC;

--- room type 
SELECT 
	rt.room_type, 
	ROUND(AVG(l.price_$),2) AS average_price, 
	ROUND(AVG(l.bedrooms),2) AS average_bedroom, 
	ROUND(AVG(l.beds),2) AS average_beds, 
	ROUND(AVG(l.accommodates),2) AS average_accommodates, 
	ROUND(AVG(ls.number_of_reviews),2) AS average_reviews, 
	ROUND(AVG(ls.review_scores_rating),2) AS average_rating, 
	AVG(l.reviews_per_month) AS average_reviewpermonth,
	COUNT (*) 
	FROM airbnb.listings l 
	INNER JOIN airbnb.listings_scrape ls ON ls.id = l.id 
	INNER JOIN airbnb.room_type rt ON rt.id = l.room_type
	GROUP BY rt.room_type ORDER BY average_price DESC;

--- room types and borough/neighbourhood 
SELECT 
	l.neighbourhood_cleansed AS LOCATION, 
	rt.room_type AS roomtype, 
	ROUND(AVG(l.price_$),2) AS average_price£, 
	ROUND(AVG(l.bedrooms),2) AS average_bedroom, 
	ROUND(AVG(l.beds),2) AS average_beds, 
	ROUND(AVG(l.accommodates),2) AS average_accommodates, 
	ROUND(AVG(ls.number_of_reviews),2) AS average_reviews, 
	ROUND(AVG(ls.review_scores_rating),2) AS average_rating, 
	AVG(l.reviews_per_month) AS average_reviewpermonth,
	ROUND(AVG(ls.availability_30),3) AS availiable_in_30days,
	ROUND(AVG(ls.availability_90),3) AS availiable_in_90days,
	ROUND (AVG(h.calculated_host_listings_count),4) AS host_list_count,
	ROUND(SUM (CASE WHEN h.host_is_superhost THEN 1 ELSE 0 END)::numeric*100 / SUM (CASE WHEN h.host_is_superhost THEN 1 ELSE 1 END)::numeric,2)  AS pct_host_superhost,
	ROUND(SUM (CASE WHEN h.host_is_superhost THEN 0 ELSE 1 END)::numeric*100 / SUM (CASE WHEN h.host_is_superhost THEN 1 ELSE 1 END)::numeric,2) AS pct_host_no_superhost,
	COUNT (*) as total_home
	FROM airbnb.listings l 
	INNER JOIN airbnb.listings_host h ON l.host_id = h.host_id
	INNER JOIN airbnb.listings_scrape ls ON ls.id = l.id 
	INNER JOIN airbnb.room_type rt ON rt.id = l.room_type
	GROUP BY (location, roomtype) ORDER BY average_price£ DESC;


 
---- host
SELECT
	ROUND(AVG(l.price_$),2) AS average_price£, 
	(CASE WHEN host_listings_count <2 THEN 'host_1or0'
		WHEN h.host_listings_count >2 AND h.host_listings_count <=3 THEN 'host_2or3'
		WHEN h.host_listings_count >3 AND h.host_listings_count <=5 THEN 'host_4or5'
		WHEN h.host_listings_count >5 AND h.host_listings_count <=7 THEN 'host_5to7'
		WHEN h.host_listings_count >7 THEN 'host_morethan7'
		ELSE 'others' END) AS RANGE, 
	COUNT(DISTINCT l.host_id) AS host_number,
	ROUND(AVG(l.bedrooms),2) AS average_bedroom, 
	ROUND(AVG(l.beds),2) AS average_beds, 
	ROUND(AVG(l.accommodates),2) AS average_accommodates, 
	ROUND(AVG(ls.number_of_reviews),2) AS average_reviews, 
	ROUND(AVG(ls.review_scores_rating),2) AS average_rating, 
	AVG(l.reviews_per_month) AS average_reviewpermonth,
	ROUND(AVG(ls.availability_30),3) AS availiable_in_30days,
	ROUND(AVG(ls.availability_90),3) AS availiable_in_90days
	FROM airbnb.listings l 
	INNER JOIN airbnb.listings_host h ON l.host_id = h.host_id
	INNER JOIN airbnb.listings_scrape ls ON ls.id = l.id 
	INNER JOIN airbnb.room_type rt ON rt.id = l.room_type
			 GROUP BY RANGE ORDER BY RANGE;
			 
			 
		
--- insteresting finding 

SELECT * FROM airbnb.reviews;


		
		
		
		
		
		
		
		
		
		
		
		








	
	
	