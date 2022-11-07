import styles from "./foo.module.scss";

(function () {
  function ready(callback) {
    // in case the document is already rendered
    if (document.readyState != "loading") callback();
    // modern browsers
    else if (document.addEventListener)
      document.addEventListener("DOMContentLoaded", callback);
    // IE <= 8
    else
      document.attachEvent("onreadystatechange", function () {
        if (document.readyState == "complete") callback();
      });
  }

  ready(function () {
    var foos = document.getElementsByClassName("foo");
    for (var i = 0; i < foos.length; i++) {
      foos[i].className = "foo " + styles.foo;
    }
  });
})();
