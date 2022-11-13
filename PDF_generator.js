function pdf_reports(tag_id,opt={
    margin:       [0.25,0.25],
    filename:     'Report.pdf',
    pagebreak: {mode: ['css', 'legacy'], avoid:['tr','td']},
    image:        { type: 'jpeg', quality: 0.98 },
    html2canvas:  { scale: 2 },
    jsPDF:        { unit: 'in', format: 'A4', orientation: 'portrait' }
    }) {
    // Converts the table and administrator's report into a 
    // PDF document with default settings shown above.
    var element = document.getElementById(tag_id);
    html2pdf().set(opt).from(element).save();   
}


