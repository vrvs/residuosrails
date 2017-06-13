// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

    $(document).ready(function(){
      $('#rb1_list').show();
      $('#rb2_list').hide();
      $('#rb3_list').hide();
      $("#rb0").click(function(){
        $("#select_bd").hide();
        $("#select_ed").hide();
        $('#rb1_list').hide();
        $('#rb2_list').hide();
        $('#rb3_list').hide();
      });
      $("#rb1").click(function(){
        $("#select_bd").show();
        $("#select_ed").show();
        $('#rb1_list').show();
        $('#rb2_list').hide();
        $('#rb3_list').hide();
      });
      $("#rb2").click(function(){
        $("#select_bd").show();
        $("#select_ed").show();
        $('#rb1_list').hide();
        $('#rb2_list').show();
        $('#rb3_list').hide();
      });
      $("#rb3").click(function(){
        $("#select_bd").show();
        $("#select_ed").show();
        $('#rb1_list').hide();
        $('#rb2_list').hide();
        $('#rb3_list').show();
      });
    });
