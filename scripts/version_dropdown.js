(function() {
  'use strict';

  // the latest version is needed, when you want to add "latest" to the dropdown, too
  // e.g. after the latest_version (CMake - dropdown - style))
  var latest_version = '0.2.3';
  var current_version_local = 'main';

  // the VERSIONS token is replaced/populated with data from the CLI
  // var versions = @VERSIONS@;

  var versions = [
      'main',
      '0.2.3',
      '0.2.2',
      '0.2.1',
      '0.2.0',
      '0.1.0'
  ];

  // RegExp for online URL (ttauri-project.org/docs/ttauri/)(main|latest|version_number)
  // "version_number" matches "major.minor" and "major.minor.patch"
  // ttauri-project\.github\.io\/docs\/
  var url_web = /(ttauri-project\.org\/docs\/ttauri\/)(main|latest|(\d\.\d+|\d\.\d+\.\d+)?)\//;

  // Regepx for local URL
  var url_local = /.*\/main\//;

  /**
   * build dropdown + display warning for main
   */
  function build_select(current_version) {
    // display a warning message, if the user switches to the "main" development branch
    if (current_version == 'main') {
      // setup alert box
      var alert_div = document.createElement("div");
      alert_div.innerHTML = '⚠️ This documentation corresponds to the <a style="font-family: monospace;" href="https://ttauri-project.org/docs/ttauri/main">main</a> development branch of TTauri. It might differ from official release versions.';
      alert_div.style.cssText = "color: #856404; background-color: #fff3cd; border-color: #ffeeba; margin: 1ex auto 1ex 1em; padding: 1ex; border-radius: 1ex; display: inline-block;"
      // insert after dropdown
      var dropdownNode = $(".project_version_dropdown")[0];
      $(alert_div).insertAfter(dropdownNode);
    }

    // build dropdown using the values from version array
    var buf = ['<select>'];
    $.each(versions, function(id) {
      var version = versions[id];
      buf.push('<option value="' + version + '"');
      if (version == current_version) {
        buf.push(' selected="selected">' + version);
      } else {
        buf.push('>' + version);
      }
      buf.push('</option>');
    });

    return buf.join('');
  }

  /**
   * update_url
   *
   * Updates the version part of the URL (with the new_vesion).
   */
  function update_url(url, new_version) {
    if(url.includes("ttauri-project.org")) {
      return url.replace(url_web, 'ttauri-project.org/docs/ttauri/' + new_version + '/');
    } else {
      return url.replace(url_local, 'E:/0-dev/ttauri-project/ttauri-project.github.io/docs/ttauri/' + new_version + '/');
    }
  }

  /**
   * on_change_switch_url
   *
   * Gets the selected version and current URL.
   * Updates the url with the selected version value.
   * Triggers a redirect, if we have a new url = not the URL of the current page/version.
   */
  function on_change_switch_url() {
    var selected = $(this).children('option:selected').attr('value');
    var url = window.location.href;
    var new_url = update_url(url, selected);
    if (new_url != url) {
      window.location.href = new_url;
    }
  }

  $(document).ready(function() {
      // get the project number node, to insert new html after it
      var projectNumberNode=$("#projectnumber")[0];

      // setup a div+span for the dropdown
      var divNode = document.createElement("div");
      divNode.className = "project_version_dropdown";
      // (inline: to be on the same line with the projectnumber span)
      divNode.style.cssText = "display: inline; margin-left: 15px;";
      divNode.textContent = "Select Version: ";

      var spanNode = document.createElement("span");
      spanNode.className = "version_dropdown";
      spanNode.textContent = "major.minor.patch";

      divNode.appendChild(spanNode);

      // insert the div after the projectnumber span
      $(divNode).insertAfter(projectNumberNode);

      // are we handling the online URL?
      var match = url_web.exec(window.location.href);
      if (match) {
        var version = match[2];
        var select = build_select(version);
        spanNode.innerHTML=select;
        $('.version_dropdown select').bind('change', on_change_switch_url);
      } else {
        // are we handling the local URL?
        match = url_local.exec(window.location.href);
        if (match) {
          var version = current_version_local;
          var select = build_select(version);
          spanNode.innerHTML=select;
          $('.version_dropdown select').bind('change', on_change_switch_url);
        }
      }
  });
})();
