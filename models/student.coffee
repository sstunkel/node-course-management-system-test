
studentModel =
	properties:
		name:
			type: 'string'
			unique: false
			index: true
			validations: ['notEmpty']

module.exports = studentModel