 {
	className: "Post",
	fields: {
	  ACL: {
	    type: "Object"
	  },
	  author: {
	    targetClass: "_User",
	    type: "Pointer"
	  },
	  content: {
	    type: "String"
	  },
	  createdAt: {
	    type: "Date"
	  },
	  objectId: {
	    type: "String"
	  },
	  updatedAt: {
	    type: "Date"
	  }
	}
 }
