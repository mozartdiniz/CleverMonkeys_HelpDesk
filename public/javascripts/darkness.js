/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function show_add_info_box(id) {

    w = document.getElementById(id);

    if (w.style.display == 'none') {

        document.getElementById('info_title').value = '';
        document.getElementById('info_text').value = '';        

        w.style.display = "block";
    } else {
        w.style.display = "none";
    }


}

function show_image_box(id, url) {

    w = document.getElementById(id);

    if (w.style.display == 'none') {

        new Ajax.Request(url, { method: 'get', onComplete: function(coisa) {
            tinyMCE.execCommand('mceInsertContent',false, coisa.responseText);
          }
        });

        w.style.display = "block";
    } else {
        w.style.display = "none";

        tinyMCE.execCommand('mceInsertContent',false, '');
    }


}

function add_content_to_editor() {

        title = document.getElementById('info_title').value;

        text = document.getElementById('info_text').value;

        html = "";

        html += "<table border='0' cellpadding='0' cellspacing='0' width='100%'><tr><td style='background-color:#A7CBFF; font-weight:bold; padding:0px;'>"

        html += "<table border='0' cellpadding='0' cellspacing='0'><tr><td valign='top' width='32'><img src='/images/info_icon.png' border=0 align=middle></td>"

        html += "<td style='font-weight:bold; padding-top:5px;' valign='middle'>" + title + "</td></tr></table>"

        html += "</td></tr>"

        html += "<tr><td style='background-color:#CFE7FF; padding:5px;'>" + text + "</td></tr>"

        html += "</table><br />"

        return  html;

}

function change_search_field_value(field_id) {
    field = document.getElementById(field_id);

    if (field.value == 'Search...') {
        field.value = '';
    } else {
        if (field.value == '') {
            field.value = 'Search...';
        }
    }
}