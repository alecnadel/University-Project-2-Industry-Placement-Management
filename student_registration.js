
// function password_acceptability_check(inputtxt) {
//     // Functional checks that the password is suitable and has at least one number 1, 
//     // 1 uppercase, 1 lowercase letter.
//     const filter = "^[A-Za-z](?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,24}[A-Za-z\d]$"
//     if(inputtxt.value.match(passw)) {
//         return true
//     } else {
//         return false
//     }   
// }

// function password_acceptability_check(password, repeated_password) {
//     if (password == repeated_password) {
//         addEventListener
//     } else {
//         return false
//     }
// }




(function () {
    "use strict";
  
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const form = document.querySelector(".registration-validation");
    
    // Variables you to check and password is correctly re-entered
    const password = document.getElementById("password");
    const repeated_password = document.getElementById("confirm-password");
    const check_password_feedback = document.getElementById("check-password");
    // Loop over them and prevent submission
     
      form.addEventListener(
        "submit",
        function (event) {
        console.log("submit")
        if ((!form.checkValidity()) ) { // || (password.value != repeated_password.value)
        // console.log("!form.checkValidity() ",!form.checkValidity())
        // console.log(password.value," == ", repeated_password.value, password.value == repeated_password.value)
        event.preventDefault();
        event.stopPropagation();
        }
        form.classList.add("was-validated");

        //   Hides or displays password re-entry failure
        if (password.value == repeated_password.value) {
        check_password_feedback.style.visibility = "hidden"; 
        } else {
        check_password_feedback.style.visibility = "visible";
        
        };
          

        },
        false
      );

    form.addEventListener(
        "keyup",
        function (event) {
        if (password.value != repeated_password.value) {
            repeated_password.setCustomValidity("Invalid field.")
        } else {
            repeated_password.setCustomValidity("")
        }
        },
        false);
    

// Initialising tooltips
var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
});
})();