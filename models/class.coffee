classModel = 
	properties:
		name:
			type: 'string'
			index: true
		course_id:
			type: 'string'
			index: true
		students:
			type: 'json'
			index: true

module.exports = classModel