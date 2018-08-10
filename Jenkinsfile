pipeline {
    agent any

    stages {
       stage ("Build Stage") {
         steps {
        checkout scm 
        echo "Creating new Stack $STACK_NAME"
        sh "./create_stack.sh $STACK_NAME"
        /* .. snip .. */
        }
      }  
   }
}
