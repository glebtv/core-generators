function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}


function number_to_currency(number, options) {
  try {
    var options   = options || {};
    var precision = options["precision"] || 2;
    var unit      = options["unit"] || "$";
    var separator = precision > 0 ? options["separator"] || "." : "";
    var delimiter = options["delimiter"] || ",";
  
    var parts = parseFloat(number).toFixed(precision).split('.');
    return number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString();
  } catch(e) {
    return number
  }
}

function number_with_delimiter(number, delimiter, separator) {
  try {
    var delimiter = delimiter || ",";
    var separator = separator || ".";
    
    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
    return parts.join(separator);
  } catch(e) {
    return number
  }
}

jQuery.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

var common = {
  setupAjaxCallbacks: function() {
    $('body').ajaxStart(function () {
      $('#global-spinner').animate({ marginTop: "0px"});
    });
    $('body').ajaxStop(function () {
      $('#global-spinner').animate({ marginTop: "-30px"});
    });
    $('body').ajaxError(function (event, xhr, ajaxOptions, thrownError) {
      if (xhr.status === 401) {
        if ($("#login").is(":hidden")) {
          app.showLoginForm();
        }
        alert("Sorry, " + xhr.responseText.toLowerCase());
      }
    });
  },
  setupAjaxCallbacksForScaffoldResources: function() {
    $('a.sort_link, .pagination a').live('click', function() {
      $('#results').load(this.href + '');
      return false;
    });
    $('form.search').ajaxForm({target: '#results'});
  },
  setupCommonEventHandlers: function() {
    $("form input[type='text']:first").focus();
    
    setTimeout(common.hideFlashes, 5000);
  },
  
  hideFlashes : function() {
    var self = this;
    var flash_messages = $(".flash .message").not(".sticky");
    flash_messages.each(function(index) {
      $(flash_messages[index]).delay(5000).fadeOut(3000);
    });
  },
  
  // Collapsable Boxes
  setupToggledBoxes: function() {  
    
    // Expanded Link
    $(".toggle h2 .collapsed-link").click(function() {
      $(this).siblings('.expanded-link').show();
      $(this).hide();
      common.contentFor($(this)).hide();
    });

    // Collapsed Link    
    $(".toggle h2 .expanded-link").click(function() {
      $(this).siblings('.collapsed-link').show(); 
      $(this).hide();
      common.contentFor($(this)).show();
    });
    
  },
  contentFor: function(element){
    return element.parents("h2").siblings('.content');
  }
}
$(function(){  
  common.setupAjaxCallbacks();
  common.setupAjaxCallbacksForScaffoldResources();
  common.setupCommonEventHandlers();
  common.setupToggledBoxes();
});

