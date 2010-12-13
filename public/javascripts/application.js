// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  function validate_ticket_form(message) {

    di_device_version = $('di_server_version').value

    di_device_version = $('di_device_version').value

    if (di_device_version == "" || di_device_version == "") {

      alert(message);

      return false;

    } else {

      return true;

    }
  }

window.onresize = function() { //your code

  var table_login = $('table_login');

  if (table_login != null) {
    table_login.style.height = document.height + 'px';
  }
};


function swap_element(id) {

  my_element = $(id)

  if (my_element.style.display == 'none') {
    my_element.style.display = 'block';
  } else {
    my_element.style.display = 'none';
  }

}

var file_index = 0

function add_file_fields(content_id, label) {
    
    var file_container = $(content_id);

    var div   = new Element('div', {'id': 'file_item', style: 'padding:5px;'});
    var input = new Element('input', {'type': 'file', name: 'comment_file[file' + file_index +']', style: 'width:400px; padding-right:10px;'});
    var a     = new Element('a', {href: 'javascript:', onclick: 'remove_files_of_this_tickets(this)'}).update(label);

    div.appendChild(input);
    div.appendChild(a);
    file_container.appendChild(div);

    file_index += 1;

}

function remove_files_of_this_tickets(e) {
    e.parentNode.remove();
}

function check_all(element, checklist) {

  var checkboxes = [];

  checkboxes = $$(checklist)


  if (element.checked == 0) {

    checkboxes.each(function(e){ e.checked = 0 });

  } else {

      checkboxes.each(function(e){ e.checked = 1 });

  }

}

function send_all_ticket_checked(id, url, parameter) {

  cheboxes = $$(id);

  var values = []

  cheboxes.each(function(e){
      if (e.checked == true) {
        values.push(e.value);
      }
  });

  new Ajax.Request(url, {parameters: 'ticket_ids=' + values + ' &value=' + parameter});
}

function changeblock(e) {

  if (e.value == "lock") {
    $('form_change_resources').action = '/user_resources/lock';
  } else {
    $('form_change_resources').action = '/user_resources/unlock';
  }

}

document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/loadinfo.green.net.gif'    

    function createSpinner() {
      return new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        el.update(createSpinner())
        /*new Ajax.Updater('chip_grid_lines', el.href, { method: 'get' })*/

        new Ajax.Request(el.href, { method: 'get' })

        /* TODO Manda sempre a requiseção para o filter
         *
         *
         *
         * */

        e.stop()
      }
    })
  }
})