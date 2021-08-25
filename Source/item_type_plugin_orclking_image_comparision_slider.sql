prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>1830538872652277
,p_default_application_id=>1006
,p_default_id_offset=>58689188019173003
,p_default_owner=>'FXO'
);
end;
/
 
prompt APPLICATION 1006 - Organization Hierarchy
--
-- Application Export:
--   Application:     1006
--   Name:            Organization Hierarchy
--   Date and Time:   12:15 Wednesday August 25, 2021
--   Exported By:     KARKUVELRAJA.T
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 199804535742315131
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     218248527712390
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/orclking_image_comparision_slider
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(199804535742315131)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'ORCLKING.IMAGE.COMPARISION.SLIDER'
,p_display_name=>'Image Comparison Slider'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION render_image_comparision_slider (',
'    p_item                IN apex_plugin.t_page_item,',
'    p_plugin              IN apex_plugin.t_plugin,',
'    p_value               IN VARCHAR2,',
'    p_is_readonly         IN BOOLEAN,',
'    p_is_printer_friendly IN BOOLEAN )',
'    RETURN apex_plugin.t_page_item_render_result ',
'    ',
'  AS  ',
'    l_result    apex_plugin.t_page_item_render_result;',
'    l_page_item_name    VARCHAR2(100);  ',
'    l_html  CLOB;',
'    l_first_img_link    apex_application_page_items.attribute_01%type := p_item.attribute_01;',
'    l_second_img_link    apex_application_page_items.attribute_02%type := p_item.attribute_02;',
'    l_img_width    apex_application_page_items.attribute_03%type := p_item.attribute_03; ',
'    l_img_height    apex_application_page_items.attribute_04%type := p_item.attribute_04;',
'    l_slider_color    apex_application_page_items.attribute_05%type := p_item.attribute_05;',
'  BEGIN',
'    -- Debug information (if app is being run in debug mode)',
'    IF apex_application.g_debug THEN',
'      apex_plugin_util.debug_page_item (p_plugin                => p_plugin,',
'                                        p_page_item             => p_item,',
'                                        p_value                 => p_value,',
'                                        p_is_readonly           => p_is_readonly,',
'                                        p_is_printer_friendly   => p_is_printer_friendly);',
'    END IF;',
'    ',
'    -- handle read only and printer friendly',
'    IF p_is_readonly OR p_is_printer_friendly THEN',
'      -- omit hidden field if necessary',
'      apex_plugin_util.print_hidden_if_readonly (p_item_name             => p_item.name,',
'                                                 p_value                 => p_value,',
'                                                 p_is_readonly           => p_is_readonly,',
'                                                 p_is_printer_friendly   => p_is_printer_friendly);',
'      -- omit display span with the value',
'      apex_plugin_util.print_display_only (p_item_name          => p_item.NAME,',
'                                           p_display_value      => p_value,',
'                                           p_show_line_breaks   => FALSE,',
'                                           p_escape             => TRUE, -- this is recommended to help prevent XSS',
'                                           p_attributes         => p_item.element_attributes);',
'    ELSE',
'      -- Not read only',
'      -- Get name. Used in the "name" form element attribute which is different than the "id" attribute ',
'      l_page_item_name := apex_plugin.get_input_name_for_page_item (p_is_multi_value => FALSE);',
'',
'     ',
'      ',
'      -- Print Image Magnifier Glass',
'      ',
'      l_html := ''<!DOCTYPE html>',
'<html>',
'<head>',
'<meta name="viewport" content="width=device-width, initial-scale=1.0">',
'<style>',
'* {box-sizing: border-box;}',
'',
'.img-comp-container {',
'  position: relative;',
'  height: 200px; /*should be the same height as the images*/',
'}',
'',
'.img-comp-img {',
'  position: absolute;',
'  width: auto;',
'  height: auto;',
'  overflow:hidden;',
'}',
'',
'.img-comp-img img {',
'  display:block;',
'  vertical-align:middle;',
'}',
'',
'.img-comp-slider {',
'  position: absolute;',
'  z-index:9;',
'  cursor: ew-resize;',
'  /*set the appearance of the slider:*/',
'  width: 40px;',
'  height: 40px;',
'  background-color: ''||nvl(l_slider_color,''#2196F3'')||'';',
'  opacity: 0.7;',
'  border-radius: 50%;',
'}',
'</style>',
'<script>',
'function initComparisons() {',
'  var x, i;',
'  /*find all elements with an "overlay" class:*/',
'  x = document.getElementsByClassName("img-comp-overlay");',
'  for (i = 0; i < x.length; i++) {',
'    /*once for each "overlay" element:',
'    pass the "overlay" element as a parameter when executing the compareImages function:*/',
'    compareImages(x[i]);',
'  }',
'  function compareImages(img) {',
'    var slider, img, clicked = 0, w, h;',
'    /*get the width and height of the img element*/',
'    w = img.offsetWidth;',
'    h = img.offsetHeight;',
'    /*set the width of the img element to 50%:*/',
'    img.style.width = (w / 2) + "px";',
'    /*create slider:*/',
'    slider = document.createElement("DIV");',
'    slider.setAttribute("class", "img-comp-slider");',
'    /*insert slider*/',
'    img.parentElement.insertBefore(slider, img);',
'    /*position the slider in the middle:*/',
'    slider.style.top = (h / 2) - (slider.offsetHeight / 2) + "px";',
'    slider.style.left = (w / 2) - (slider.offsetWidth / 2) + "px";',
'    /*execute a function when the mouse button is pressed:*/',
'    slider.addEventListener("mousedown", slideReady);',
'    /*and another function when the mouse button is released:*/',
'    window.addEventListener("mouseup", slideFinish);',
'    /*or touched (for touch screens:*/',
'    slider.addEventListener("touchstart", slideReady);',
'    /*and released (for touch screens:*/',
'    window.addEventListener("touchend", slideFinish);',
'    function slideReady(e) {',
'      /*prevent any other actions that may occur when moving over the image:*/',
'      e.preventDefault();',
'      /*the slider is now clicked and ready to move:*/',
'      clicked = 1;',
'      /*execute a function when the slider is moved:*/',
'      window.addEventListener("mousemove", slideMove);',
'      window.addEventListener("touchmove", slideMove);',
'    }',
'    function slideFinish() {',
'      /*the slider is no longer clicked:*/',
'      clicked = 0;',
'    }',
'    function slideMove(e) {',
'      var pos;',
'      /*if the slider is no longer clicked, exit this function:*/',
'      if (clicked == 0) return false;',
'      /*get the cursor''''s x position:*/',
'      pos = getCursorPos(e)',
'      /*prevent the slider from being positioned outside the image:*/',
'      if (pos < 0) pos = 0;',
'      if (pos > w) pos = w;',
'      /*execute a function that will resize the overlay image according to the cursor:*/',
'      slide(pos);',
'    }',
'    function getCursorPos(e) {',
'      var a, x = 0;',
'      e = (e.changedTouches) ? e.changedTouches[0] : e;',
'      /*get the x positions of the image:*/',
'      a = img.getBoundingClientRect();',
'      /*calculate the cursor''''s x coordinate, relative to the image:*/',
'      x = e.pageX - a.left;',
'      /*consider any page scrolling:*/',
'      x = x - window.pageXOffset;',
'      return x;',
'    }',
'    function slide(x) {',
'      /*resize the image:*/',
'      img.style.width = x + "px";',
'      /*position the slider:*/',
'      slider.style.left = img.offsetWidth - (slider.offsetWidth / 2) + "px";',
'    }',
'  }',
'}',
'</script>',
'</head>',
'<body>',
'',
'<div class="img-comp-container">',
'  <div class="img-comp-img">',
unistr('    <img id="myimage_''||l_page_item_name||''" src="''||nvl(l_second_img_link,''http://2.bp.blogspot.com/-g4u7SML5N1Q/X9nObb_hJzI/AAAAAAAAXjU/lKdcY4WSp7Iq0\20261600/purepng.com-oracle-logologobrand-logoiconslogos-251519939816xngul.png'')||''" width="''||nvl(l_i')
||'mg_width,300)||''" height="''||nvl(l_img_height,200)||''">',
'  </div>',
'  <div class="img-comp-img img-comp-overlay">',
'    <img id="myimage_''||l_page_item_name||''" src="''||nvl(l_first_img_link,''https://1.bp.blogspot.com/-FP3iRbTPS3Y/YRYVqLuIaCI/AAAAAAAAcmo/PGgazY72NbU29dHwuLuJMyJmGL7leivNACLcBGAsYHQ/s267/Oracle%2BACE%2BImage.jpg'')||''" width="''||nvl(l_img_width,300)||'
||'''" height="''||nvl(l_img_height,200)||''">',
'  </div>',
'</div>',
'',
'<script>',
'/*Execute a function that will execute an image compare function for each element with the img-comp-overlay class:*/',
'initComparisons();',
'</script>',
'',
'</body>',
'</html>'';',
'      ',
'      l_result.is_navigable := FALSE;',
'    END IF; ',
'    sys.htp.p(l_html);',
'    RETURN l_result;',
'  END render_image_comparision_slider;',
'  '))
,p_api_version=>1
,p_render_function=>'render_image_comparision_slider'
,p_standard_attributes=>'VISIBLE:ELEMENT:ELEMENT_OPTION'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/tkarkuvelraja/image_comparison_slider_apex_plugin'
,p_files_version=>8
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(199804744024315147)
,p_plugin_id=>wwv_flow_api.id(199804535742315131)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'First Image Link'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'http://2.bp.blogspot.com/-g4u7SML5N1Q/X9nObb_hJzI/AAAAAAAAXjU/lKdcY4WSp7Iq04B_k4k3qzCGRi3mUXb6QCK4BGAYYCw/s1600/purepng.com-oracle-logologobrand-logoiconslogos-251519939816xngul.png'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(199829129635425636)
,p_plugin_id=>wwv_flow_api.id(199804535742315131)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Second Image Link'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'http://2.bp.blogspot.com/-g4u7SML5N1Q/X9nObb_hJzI/AAAAAAAAXjU/lKdcY4WSp7Iq04B_k4k3qzCGRi3mUXb6QCK4BGAYYCw/s1600/purepng.com-oracle-logologobrand-logoiconslogos-251519939816xngul.png'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(199829813780429038)
,p_plugin_id=>wwv_flow_api.id(199804535742315131)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Img. Width'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'300'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(199830150809430026)
,p_plugin_id=>wwv_flow_api.id(199804535742315131)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Img. Height'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'200'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(199840009205528616)
,p_plugin_id=>wwv_flow_api.id(199804535742315131)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Slider Color'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_default_value=>'#2196F3'
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
