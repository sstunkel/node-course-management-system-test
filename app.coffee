#App.Coffee


#Base Setup
#call the packages we need
express = require 'express'
app = express()
bodyParser = require 'body-parser'

#setupRedisclient and ORM
redis = (require 'redis').createClient(13135, 'pub-redis-13135.us-east-1-3.2.ec2.garantiadata.com',
	auth_pass: 'test')
Nohm = (require 'nohm').Nohm
Nohm.setPrefix('ArccosGolfTest')

#import Models
Nohm.model('Student',require './models/student')
Nohm.model('Class',require './models/class')
Nohm.setClient(redis)

#configure bodyparser
app.use(bodyParser.urlencoded(
	extended: true
	)
)
app.use(bodyParser.json())

port = process.env.PORT or 8080 #set port

#Routes for our API
router = express.Router()

#middleware for all routes
router.use (req,res, next) ->
	console.log("Processing API request of type #{(req.method)} at URL #{req.url}");
	next();

#index API route
router.get('/', (req,res) ->
	res.json(
			message : 'Welcome to our API!'
		)
)

#students route
router.route('/students')
	#create a new student, name in body of post request
	.post (req, res) ->
		student = Nohm.factory('Student', (err) ->
			res.send(err))
		student.p('name', req.body.name)
		student.save (err) ->
			res.send(err) if err
			res.json student
	#gets IDs of all students
	.get (req, res) ->
		student = Nohm.factory('Student', (err) ->
			res.send(err))
		student.find (err, ids) ->
			res.send(err) if err
			res.json ids
			res.json(
					message: 'No Students Found'
				)
#courses route
router.route('/courses')
	#lists all courses
	.get (req,res) ->
		Class = Nohm.factory('Class', (err) ->
			res.send(err))
		Class.find(err, ids) ->
			res.send(err) if err
			res. json ids #returns ids of all courses
		
router.route('/courses/:course_id')
	.get (req, res) ->
		Class = Nohm.factory('Class', (err)->
			res.send(err) if err)
		Class.find(
			someString: req.params.course_id
			, (err,ids) ->
				res.send(err) if err
				res.json ids[0] #returns id of first course that matched the course id
			)
#list ids of all students in course route
router.route('/courses/:course_id/listStudents')
	.get (req, res) ->
		Class = Nohm.factory('Class', (err)->
			res.send(err) if err)
		Class.find(
			someString: req.params.course_id
			, (err,ids) ->
				res.send(err) if err
				Class.load(ids[0])
				res.json Class.p('students') #returns ids of students enrolled in course
			)

#add student to course route
router.route('/courses/:course_id/addStudents/:student_id')
	.get (req, res) ->
		Class = Nohm.factory('Class', (err)->
			res.send(err) if err)
		Class.find(
			someString: req.params.course_id
			, (err,ids) ->
				res.send(err) if err
				Class.load(ids[0])
				Class.p('students').push(req.params.course_id) #pushes new student on course
				res.json Class.p('students') #returns ids of students enrolled in course
			)




app.use('/api', router)

app.listen port

console.log "Server listening on #{port}"
