classModel = 
	properties:
		name:
			type: 'string'
			index: true
			validations: ['notEmpty']
		course_id:
			type: 'string'
			index: true
			validations: ['notEmpty']
		students:
			type: 'json'
			index: true

module.exports = classModel