/**
 * Created by Rat on 8/26/2016.
 */
var express = require('express');
var router = express.Router();
var mysql = require('mysql');

//  TODO: Add a user sign-in system
//  This sytem will need to use either Passport.js, or an easy to use and integrate system
//  Return function will properly resolve and run the service as needed on layout
var check = function() {
    var data = 'nodata';
    var connection = mysql.createConnection({});
    connection.connect();
    var LQ = "CALL sp_SIAC()";
    connection.query(LQ, function(err, results, fields) {
        if (err) {
            
        }
        data = results[1];
        console.log(data);
        connection.end();
    });
    console.log(data);
    return true;
}




/* Home page. */
router.get('/', function(req, res, next) {
    var status = check();
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = 'CALL sp_Announce()';
    connection.query(linkQuery, function (err, results, fields) {
        if (err) {
            results = null;
        }
        console.log(status);
        if ( status != undefined) {
            console.log(status);
            res.render('index', {LS: status, CorpTitle: "Convention Services", title: 'Convention Services Internal Tools',data: results[0], year: "2016-2017"});
        }
    });
    connection.end();
});

//---------------------------------------------------------------------//

//---------------------------------------------------------------------//

router.get('/announcements', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_RetAnnounce(?)";
    connection.query(linkQuery,["PostedDate"], function(err, results, fields) {
        if (err) {
            results = null;
        }
        res.render('announcements', {sorted:'Newest First', data: results[0], err: null});
    });
    connection.end();
});

router.get('/create-announcement', function(req,res,next) {
    res.render('create-announcement');
});

router.get('/submit-announcement', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_createAnnounce(?,?)";
    connection.query(linkQuery,[req.body.severity,req.body.textinfo], function(err,results,fields) {
        if (err) {
            results = null;
        }
        res.render('create-announcement', {ticker: "Announcement created successfully"});
    });
    connection.end();
});


router.get('/announcements/severity', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_RetAnnounce(?)";
    connection.query(linkQuery,['Severity'], function(err, results, fields) {
        if (err) {
            results = null;
        }
        res.render('announcements', {sorted:'Severity', data: results[0], err: null});
    });
    connection.end();
});

router.get('/announcements/Active', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_RetAnnounce(?)";
    connection.query(linkQuery,['Active'], function(err, results, fields) {
        if (err) {
            results = null;
        }
        res.render('announcements', {sorted:'Active', data: results[0], err: null});
    });
    connection.end();
});

//---------------------------------------------------------------------//
                    // Time clock re-directions
//---------------------------------------------------------------------//

router.get('/timeclock', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = 'SELECT * FROM TimeClock';
    connection.query(linkQuery, function (err, results, fields) {
        if (err) {
            results = null;
        }
        console.log('DATA \n');
        console.log(results);
        res.render('timeclock', {title: 'Viewing all Volunteers timesheet history.', data: results, err: null});
    });
    connection.end();
});


router.get('/timeclock/active', function(req,res,next) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_CIVolunteers()";
    connection.query(linkQuery, function(err,response) {
        if (err) {
            response = err;
        }
        console.log(response[0]);
        res.render('timeclock', {title: "Viewing clocked-in Volunteers.", data: response[0], err: null});
    });
    connection.end();
});

//---------------------------------------------------------------------//

router.post('/submittime', function(req,res) {
    // var connection = mysql.createConnection({user: "enzo_leon", password: '', database: "c9"});
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_TimeP(?,?,?,?);";
    var qData;
    
    connection.query(linkQuery,[req.body.badgenumber, req.body.clocktype,req.body.department,1], function (err,reply) {
        if (err) {
            console.log(err);
            reply = "error - " + err;
        }
        console.log(reply);
        res.render('submittime', {data: reply[1],err: null});
        connection.end();
    });
});

router.post('/search', function (req,res) {
    var connection = mysql.createConnection({});
    connection.connect();
    var linkQuery = "CALL sp_Search(?,?,?)";
    var viewfield = req.body.searchQuery1;
    connection.query(linkQuery,[req.body.searchType,req.body.searchQuery1,req.body.searchQuery2], function(err,reply) {
        if (err) {
            console.log(err);
            reply = "Error."
        }
        res.render('search', {queries: reply[0], err:null});
    })
    connection.end();
});

module.exports = router;