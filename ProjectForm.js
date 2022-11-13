
document.addEventListener("DOMContentLoaded", function () { 
(function () {
function Project(currentYear) {
    // function creates in new project input section

    var container = document.getElementById("projects")
    var cur_idx = Number(document.querySelectorAll(".ProjectSection").length)
    console.log("cur_idx",cur_idx)
    const idx = cur_idx + 1
    console.log("idx",idx)
    var divproject = document.createElement("div");
    divproject.classList = ["ProjectSection mb-4"]

    var ProjectRow = document.createElement("div");
    ProjectRow.classList = ["row"]

    var col_1 = document.createElement("div");
    col_1.classList = ["col-md-4 form-group mb-4"]
    var label_1 = document.createElement("label");
    label_1.classList = ["form-label"]
    label_1.htmlFor = `year_${idx}`
    label_1.innerText = "Year:";
    var input_1 = document.createElement("input");
    input_1.classList = ["form-control"];
    input_1.min=1900;
    input_1.max=2199;
    input_1.step=1;
    input_1.id= `year_${idx}`
    input_1.name= `year_${idx}`
    input_1.value= currentYear
    input_1.type="number";
    input_1.required=true;
    var div_feedback_1 = document.createElement("div");
    div_feedback_1.classList = ["invalid-feedback"]
    div_feedback_1.innerText = "Please enter the Year of the project"
    col_1.appendChild(label_1);
    col_1.appendChild(input_1);
    col_1.appendChild(div_feedback_1);
    ProjectRow.appendChild(col_1);

    var col_2 = document.createElement("div");
    col_2.classList = ["col-md-4 form-group mb-4"]
    var label_2 = document.createElement("label");
    label_2.classList = ["form-label"]
    label_2.htmlFor = `semester_${idx}`
    label_2.innerText = "Select Semester:";

    const select_node = document.getElementById("semester_1");
    var select_1 = select_node.cloneNode(true);
    // var select_1 = document.createElement("select");
    // select_1.classList = ["form-control"];
    select_1.id=`semester_${idx}`
    select_1.name=`semester_${idx}`
    // var option_1 = document.createElement("option");
    // option_1.value=1
    // option_1.innerText="Semester 1"
    // var option_2 = document.createElement("option");
    // option_2.value=2
    // option_2.innerText="Semester 2"
    col_2.appendChild(label_2);
    col_2.appendChild(select_1);
    // select_1.appendChild(option_1);
    // select_1.appendChild(option_2);
    ProjectRow.appendChild(col_2);

    // <div class="col-md-4 form-group">
    //     <label for="potential_placements" class="form-label">Number of Potential Placements:</label>
    //     <input class="form-control" type="number" min="1" max="10" step="1" value="1" 
    //             id="potential_placements" name="potential_placements" />
    //     <div class="invalid-feedback">
    //         Please enter the number of potential students from min 1 to max 10 
    //     </div>
    // </div>

    var col_3 = document.createElement("div");
    col_3.classList = ["col-md-4 form-group mb-4"]
    var label_3 = document.createElement("label");
    label_3.classList = ["form-label"]
    label_3.htmlFor = `potential_placements_${idx}`
    label_3.innerText = "Number of Potential Placements:";
    var input_2 = document.createElement("input");
    input_2.classList = ["form-control"];
    input_2.min=1;
    input_2.max=10;
    input_2.step=1;
    input_2.value=1
    input_2.type="number"
    input_2.id=`potential_placements_${idx}`
    input_2.name=`potential_placements_${idx}`
    input_2.required=true
    var div_feedback_2 = document.createElement("div");
    div_feedback_2.classList = ["invalid-feedback"]
    div_feedback_2.innerText = "Please enter the number of potential students from min 1 to max 10 "
    col_3.appendChild(label_3);
    col_3.appendChild(input_2);
    col_3.appendChild(div_feedback_2);
    ProjectRow.appendChild(col_3);

    var techRow = document.createElement("div");
    techRow.classList = ["row"]



    var col_4 = document.createElement("div");
    col_4.classList = ["col-md-4 form-group mb-4"]
    var label_4 = document.createElement("label");
    label_4.classList = ["form-label"]
    label_4.htmlFor = `tech_name_${idx}`
    label_4.innerText = "Technical person name:";
    var input_3 = document.createElement("input");
    input_3.classList = ["form-control Tech"];
    input_3.type="text"
    input_3.id=`tech_name_${idx}`
    input_3.name=`tech_name_${idx}`
    input_3.placeholder="Name"
    input_3.setAttribute("list", `TechPersonNames_${idx}`)
    input_3.required=true
    const node = document.getElementById("TechPersonNames");
    var datanames = node.cloneNode(true);
    datanames.id = `TechPersonNames_${idx}`
    var techId = document.createElement("input");
    techId.type="hidden"
    techId.id=`techId_${idx}`
    techId.name=`techId_${idx}`
    techId.value=-1
    var div_feedback_3 = document.createElement("div");
    div_feedback_3.classList = ["invalid-feedback"]
    div_feedback_3.innerText = "This is a required Fields."
    col_4.appendChild(label_4);
    col_4.appendChild(input_3);
    col_4.appendChild(datanames);
    col_4.appendChild(techId);
    col_4.appendChild(div_feedback_3);
    techRow.appendChild(col_4);


    var col_5 = document.createElement("div");
    col_5.classList = ["col-md-4 form-group mb-4"]
    var label_5 = document.createElement("label");
    label_5.classList = ["form-label"]
    label_5.htmlFor = `tech_phone_${idx}`
    label_5.innerText = "Technical person phone number:";
    var input_4 = document.createElement("input");
    input_4.classList = ["form-control"];
    input_4.type="text"
    input_4.id=`tech_phone_${idx}`
    input_4.name=`tech_phone_${idx}`
    input_4.placeholder="phone number"
    input_4.required=true
    input_4.pattern="^\(*([0]\d{1,3})\)*([- ]*)(\d{3,4})\2(\d{3,4}$)|^*([0]\d{1,3})*([- ]*)(\d{3,4})\2(\d{3,4}$)"
    var div_feedback_4 = document.createElement("div");
    div_feedback_4.classList = ["invalid-feedback"]
    div_feedback_4.innerText = "This is a required Fields."
    col_5.appendChild(label_5);
    col_5.appendChild(input_4);
    col_5.appendChild(div_feedback_4);
    techRow.appendChild(col_5);


    var col_6 = document.createElement("div");
    col_6.classList = ["col-md-4 form-group mb-4"]
    var label_6 = document.createElement("label");
    label_6.classList = ["form-label"]
    label_6.htmlFor = `tech_email_${idx}`
    label_6.innerText = "Technical person email address:";
    var input_5 = document.createElement("input");
    input_5.classList = ["form-control"];
    input_5.type="email"
    input_5.id=`tech_email_${idx}`
    input_5.name=`tech_email_${idx}`
    input_5.placeholder="Email address"
    input_5.required=true
    var div_feedback_5 = document.createElement("div");
    div_feedback_5.classList = ["invalid-feedback"]
    div_feedback_5.innerText = "This is a required Fields."
    col_6.appendChild(label_6);
    col_6.appendChild(input_5);
    col_6.appendChild(div_feedback_5);
    techRow.appendChild(col_6);

    var descriptionRow = document.createElement("div");
    descriptionRow.classList = ["row"]


    var col_7 = document.createElement("div");
    col_7.classList = ["col form-group mb-4"]
    var label_7 = document.createElement("label");
    label_7.classList = ["form-label"]
    label_7.htmlFor = `ProjectDescription_${idx}`
    label_7.innerText = "Project Description:";
    var input_6 = document.createElement("textarea");
    input_6.classList = ["form-control"];
    input_6.type="email"
    input_6.id=`ProjectDescription_${idx}`
    input_6.name=`ProjectDescription_${idx}`
    input_6.required=true
    var div_feedback_6 = document.createElement("div");
    div_feedback_6.classList = ["invalid-feedback"]
    div_feedback_6.innerText = "This is a required Fields."
    col_7.appendChild(label_7);
    col_7.appendChild(input_6);
    col_7.appendChild(div_feedback_6);
    descriptionRow.appendChild(col_7);

    divproject.appendChild(ProjectRow);
    divproject.appendChild(techRow);
    divproject.appendChild(descriptionRow);

    container.appendChild(divproject);

    const Projectsnumber = Number(document.querySelectorAll(".ProjectSection").length) 
    // console.log("Projectsnumber",Projectsnumber)
    var projectCount = document.getElementById("projectCount")
    projectCount.value=Projectsnumber
    // console.log("projectCount.value",projectCount.value)
};
 
function data_for_TechData(querySelector_str) {
    const data = document.querySelectorAll(querySelector_str)
    var NewArray = Array();
    data.forEach(function (element) { 
        var value = element.value.split(",");
        NewArray.push(value)

     })
    return NewArray
};

document.getElementById("TechPersonNames")

function data_for_TechName(querySelector_str) {
    const techdatalist = document.getElementById("TechPersonNames")
    const data = techdatalist.querySelectorAll(querySelector_str)
    var NewArray = Array();
    data.forEach(function (element) { 
        var value = element.value;
        NewArray.push(value)

     })
    return NewArray
};

function TechPersonFormControl(techInput) {
    //   controls the input of tech peron data.
    
        // const document.querySelectorAll(".TechName")
        console.log("stuff 3")
        var TechName = data_for_TechName(".TechName");

        
        var TechData = data_for_TechData(".TechData");
        
        var techphone = techInput.parentElement.parentElement.children[1].children[1]
        var techemail = techInput.parentElement.parentElement.children[2].children[1]
        var techid = techInput.parentElement.children[3]
        
        if (TechName.includes(techInput.value)) {
            
            // TechData.forEach(function (element,techphone,techemail) { 
            for (let i = 0; i < TechData.length; i++) {
                
                const element = TechData[i];

                console.log("element ",element,"TechName ",TechName)
                if (element.includes(techInput.value)) {
                    techphone.value=element[2]
                    techemail.value=element[3]
                    techphone.setAttribute("readonly","") 
                    techemail.setAttribute("readonly","")  //.disabled=true
                    techid.value=element[1]
                };
            };
            //  })

        } else {
            techphone.removeAttribute("readonly")
            techemail.removeAttribute("readonly")
            techid.value=-1
        };
};

function techInputsEl() {
    var techInputs1 = document.querySelectorAll(".Tech");
    return techInputs1
}

const year = Number(document.getElementById("year_data").value);
const NewProject = document.querySelector(".NewProject");
NewProject.addEventListener('click', function(){Project(year)},false);

// const techInputs = document.querySelectorAll(".Tech")
// this.gridButtons = this.el.querySelectorAll('button.btn-click-me');
// this.techInputs = [].slice.call(this.techInputsraw);

    NewProject.addEventListener("click", function () {
        var techInputs1 = document.querySelectorAll(".Tech");

        techInputs1.forEach(function(techInput) {
            // var techInput = techInput
            ["keyup", "input" ].forEach(function(event){ // ,"click"
                console.log("event",event)
                techInput.addEventListener(event,function(){TechPersonFormControl(techInput)},false);
            })
            
            });
        window.addEventListener("load",function () { 
            techInputs1.forEach(techInput => {
                TechPersonFormControl(techInput)
            });
         });

        },false)

var techInputs1 = document.querySelectorAll(".Tech");
techInputs1.forEach(function(techInput) {
    // var techInput = techInput
    ["keyup", "input" ].forEach(function(event){ // ,"click"
        console.log("event",event)
        techInput.addEventListener(event,function(){TechPersonFormControl(techInput)},false);
    })
    
    });
window.addEventListener("load",function () { 
    techInputs1.forEach(techInput => {
        TechPersonFormControl(techInput)
    });
 });
// var options = document.querySelectorAll(".TechData");
// options.forEach(function(option) {
//     option.addEventListener("click",function () { 
//     techInputs1.forEach(techInput => {
//         TechPersonFormControl(techInput)
//     });
//  });
// });

// var techInputs2 = document.querySelectorAll(".Tech");
// techInputs2.forEach(techInput2 => {
//     techInput2.addEventListener("change",function(){TechPersonFormControl(techInput2)},false);
//     });

// var techInputs3 = document.querySelectorAll(".Tech");
// techInputs3.forEach(techInput3 => {
//     techInput3.addEventListener("keyup",function(){TechPersonFormControl(techInput3)},false);
//     });
})();
});


(function enable_submit() {
    "use strict";
  
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const forms = document.querySelectorAll(".needs-validation");
  
    // Loop over them and prevent submission
    Array.prototype.slice.call(forms).forEach(function (form) {
      form.addEventListener(
        "submit",
        function (event) {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          } else {
            // var techInput = document.querySelectorAll(".Tech");
            // techInput.forEach(element => {
            // var techphone = element.parentElement.parentElement.children[1].children[1]
            // var techemail = element.parentElement.parentElement.children[2].children[1]
            // if (techphone.disabled=true) {
            //     techphone.disabled=false
            //     techemail.disabled=false
            // }
            // });
            
          }

          
          form.classList.add("was-validated");
        },
        false
      );
    });
  })();