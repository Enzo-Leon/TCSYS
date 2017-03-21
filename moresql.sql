/* Project
-- Build a wworking timeclock system for a convention of
  5,000+ attendees with a staff of 200+
- Project needs to be able handle multiple possible uses
  where multiple terminals are logging data into and out of the
  system.

DATA NEEDED
    OVERALL FOR TIMECLOCK
    Badge ID
    FANDOM Name
    First/Last Name
    ClockType (In/Break Out/Break In/Out)
    Date & Time (Posted in full timestamp)
    Department
    Admin Signed in handling Punch
    
    = Admin Table
    Badge ID
    Fandom Name
    First/Last Name
    Department
    
*/

-- USEFUL QUERIES
--      SELECT * FROM TimeClock WHERE BadgeNum=? ORDER BY ID DESC; //This will run a check of all data where the BadgeNum (badge number) equals the request and will sort from oldest to newest 

--  TABLE INFO
--  This table is the time clock that will handle volunteer timepunch information
DROP TABLE IF EXISTS TimeClock;
CREATE TABLE IF NOT EXISTS TimeClock(ID INT AUTO_INCREMENT PRIMARY KEY, BadgeNum INT NOT NULL,ActShif TINYINT(1),
    CI TIMESTAMP DEFAULT CURRENT_TIMESTAMP,CO TIMESTAMP NULL, Department VARCHAR(50) NOT NULL, SIAdmin INT NOT NULL);

--  This table stores a volunteers total hours volunteered and shifts completed 
DROP TABLE IF EXISTS HoursSheet;
CREATE TABLE IF NOT EXISTS HoursSheet (BadgeNum IN NOT NULL PRIMARY KEY, TotalHours FLOAT NOT NULL, ShiftsV INT NOT NULL);
--  This TABLE will need to be structed in a way that acn support a repeating 



-- EXTRA QUERIES
SELECT TimeClock.BadgeNum, HoursSheet.TotalHours, HoursSheet.ShiftsV FROM TimeClock 
    JOIN HoursSheet ON TimeClock.BadgeNum=HoursSheet.BadgeNum ORDER BY TimeClock.BadgeNum;


--  SQL QUERY AND PROCEDURE WORK

