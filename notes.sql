/* //////////////////////////////// TIMECLOCK Punch in/out SYSTEM SQL QUERIES //////////////////////////// */
/* //////////////////////////////////   SQL PROCEDURE #1  ///////////////////////////////////////// */

DROP TABLE IF EXISTS TimeClock;
CREATE TABLE IF NOT EXISTS TimeClock(ID INT AUTO_INCREMENT PRIMARY KEY, BadgeNum INT NOT NULL,
    ActShif TINYINT(1), CI TIMESTAMP DEFAULT CURRENT_TIMESTAMP,CO TIMESTAMP NULL,
    Department VARCHAR(50) NOT NULL, SIAdmin INT NOT NULL);

DROP PROCEDURE IF EXISTS sp_TimeP;
DELIMITER $$

CREATE PROCEDURE sp_TimeP(IN a INT, IN b INT, IN c VARCHAR(50), IN d INT)
BEGIN
	DECLARE BN INT;
	DECLARE ActS INT;
	DECLARE DEPT VARCHAR(50);
	DECLARE SIA INT;
    DECLARE Response VARCHAR(75) DEFAULT '';
    DECLARE TS FLOAT;
	SET BN = a, ActS = b, DEPT = c, SIA = d;

	SELECT SQL_CALC_FOUND_ROWS BadgeNum, ActShif, Department 
	FROM TimeClock WHERE BadgeNum=BN AND ActShif=1;
    
	IF FOUND_ROWS() = 0 AND ActS = 1 THEN
	    START TRANSACTION;
        	INSERT INTO TimeClock (BadgeNum,ActShif,Department,SIAdmin) VALUES (BN,ActS,DEPT,SIA);
        	INSERT INTO HoursSheet (BadgeNum,TotalHours,ShiftsV) 
        	SELECT * FROM (SELECT BN,000.00,0) AS tmp
        	    WHERE NOT EXISTS (
        	        SELECT BadgeNum FROM HoursSheet WHERE BadgeNum=BN  
    	        ) LIMIT 1;
    	COMMIT;
    	SELECT "Volunteer Clocked in." INTO Response;
	ELSEIF FOUND_ROWS() > 0 AND ActS=0 THEN 
    	SELECT "Volunteer Clocked out." INTO Response;
    	SELECT Response;
	    SELECT TIMESTAMPDIFF(SECOND,CI,CURRENT_TIMESTAMP())/3600 
	    FROM TimeClock WHERE BadgeNum=BN AND ActShif=1 INTO TS;
	    UPDATE TimeClock 
        	SET ActShif=ActS, CO=CURRENT_TIMESTAMP() WHERE BadgeNum=BN AND ActShif = 1;
	    CALL sp_HoursCalc(BN,TS);
	ELSE
	    SELECT "Invalid punch. Please try again." INTO RESPONSE;
	END IF;

	SELECT Response;

END $$
DELIMITER ;

/* //////////////////////////////////   SQL PROCEDURE #2   ///////////////////////////////////////// */

DROP TABLE IF EXISTS HoursSheet;
CREATE TABLE IF NOT EXISTS HoursSheet(BadgeNum INT NOT NULL PRIMARY KEY, TotalHours DECIMAL(5,2) NOT NULL, ShiftsV INT NOT NULL);

DROP PROCEDURE IF EXISTS sp_HoursCalc;

DELIMITER $$

CREATE PROCEDURE sp_HoursCalc (IN a INT, IN b DECIMAL(4,2))
BEGIN
    DECLARE BN INT;
    DECLARE TH DECIMAL(4,2);
    
    SET BN = a, TH = b;
    
    SELECT SQL_CALC_FOUND_ROWS BadgeNum FROM HoursSheet WHERE BadgeNum=BN;
    
    IF FOUND_ROWS() = 0 THEN INSERT INTO HoursSheet (BadgeNum,TotalHours,ShiftsV) VALUES (BN,TH,1);
    ELSE
    UPDATE HoursSheet
    SET TotalHours = TotalHours + TH, ShiftsV = ShiftsV + 1
    WHERE BadgeNum = BN;
    END IF;    
    
END $$

DELIMITER ;

/* //////////////////////////////////   SQL PROCEDURE #3   ///////////////////////////////////////// */

DROP PROCEDURE IF EXISTS sp_Search;
DELIMITER $$


CREATE PROCEDURE sp_search(IN a VARCHAR(50),IN b INT,IN c VARCHAR(50))
BEGIN
    DECLARE ST VARCHAR(50);
    DECLARE SQ1 INT DEFAULT 0;
    DECLARE SQ2 VARCHAR(50) DEFAULT '';
    DECLARE Response VARCHAR(2500) DEFAULT '';
    SET ST=a, SQ1=b, SQ2=c;
    
    IF ST = "Department" THEN
        SELECT DISTINCT TimeClock.BadgeNum, TimeClock.Department, HoursSheet.*
            FROM TimeClock
            JOIN HoursSheet 
            ON TimeClock.BadgeNum=HoursSheet.BadgeNum AND TimeClock.Department=SQ2 ORDER BY TimeClock.BadgeNum ASC;
    ELSE
        SELECT DISTINCT TimeClock.BadgeNum, TimeClock.Department, HoursSheet.*
            FROM TimeClock
            JOIN HoursSheet 
            ON TimeClock.BadgeNum=HoursSheet.BadgeNum AND TimeClock.BadgeNum=SQ1 ORDER BY TimeClock.BadgeNum ASC;
    END IF;
    
END $$

DELIMITER ;

/* //////////////////////////////////   SQL PROCEDURE #4  ///////////////////////////////////////// */

DROP TABLE IF EXISTS Announcements;
CREATE TABLE IF NOT EXISTS Announcements (PostedDate TIMESTAMP, Content VARCHAR(300),
    AdminName VarChar(50),Severity VarChar(20), Active TINYINT(1));

DROP PROCEDURE IF EXISTS sp_Announce;

DELIMITER $$

CREATE PROCEDURE sp_Announce()
BEGIN
    SELECT * FROM Announcements ORDER BY PostedDate DESC LIMIT 2;
END $$

DELIMITER ;

INSERT INTO Announcements(Content,AdminName,Severity) VALUES 
    ("Attention: Events center will need to be closed at 5PM to 7PM for emergency cleaning.","Tyco","5");

/* //////////////////////////////////   SQL PROCEDURE #5  ///////////////////////////////////////// */

DROP PROCEDURE IF EXISTS sp_RetAnnounce;

DELIMITER $$

CREATE PROCEDURE sp_RetAnnounce(IN a VARCHAR(15))
BEGIN
    DECLARE SQ VARCHAR(15);
    SET SQ = a;
    SELECT * FROM Announcements ORDER BY CASE SQ
        WHEN 'Active' THEN Active
        WHEN 'PostedDate' THEN PostedDate
        WHEN 'Severity' THEN Severity
        END DESC;
END $$

DELIMITER ;

/* //////////////////////////////////   SQL PROCEDURE #6  ///////////////////////////////////////// */

DROP PROCEDURE IF EXISTS sp_CIVolunteers;

DELIMITER $$

CREATE PROCEDURE sp_CIVolunteers()
BEGIN
    -- This Query will do a search of all volunteers who have an active clock in punch
    -- this will ALSO join information from the total hours section showing how long
    -- the volunteer has been previously clocked in
    SELECT TimeClock.* , HoursSheet.TotalHours 
        FROM TimeClock
        JOIN HoursSheet 
        ON TimeClock.BadgeNum=HoursSheet.BadgeNum AND TimeClock.CO IS NULL;
END $$

DELIMITER ;


/* //////////////////////////////////   SQL PROCEDURE #7  ///////////////////////////////////////// */


DROP PROCEDURE IF EXISTS sp_createAnnounce;

DELIMITER $$

CREATE PROCEDURE sp_createAnnounce(IN a INT, IN b VARCHAR(500))
BEGIN
    DECLARE 




/* //////////////////////////////////   SQL PROCEDURE #8  ///////////////////////////////////////// */
/*  THIS IS THE SECTION THAT WILL HANDLE THE LOGIN/VERIFICATION INFORMATION AND SUSTAIN A LOGIN 
    TO LOCAL STORAGE FOR THE CLIENT TO REVIEW AND PROCESS A TOKEN
    
                                WIP / WIP / WIP / WIP / WIP / WIP
*/

DROP TABLE IF EXISTS SIAdmins;

CREATE TABLE SIAdmins (BadgeNum INT NOT NULL,AdminName VARCHAR(75) NOT NULL);

DROP PROCEDURE IF EXISTS sp_SIAC;

DELIMITER $$

CREATE PROCEDURE sp_SIAC()
BEGIN
    DECLARE R VARCHAR(10) DEFAULT "FALSE";
    
    SELECT SQL_CALC_FOUND_ROWS BadgeNum FROM SIAdmins WHERE BadgeNum=1;
    
    IF FOUND_ROWS() = 0 THEN
        SELECT "FALSE" INTO R;
    ELSE
        SELECT "TRUE" INTO R;
    END IF;
    
    SELECT R;
    
END $$

DELIMITER ;



