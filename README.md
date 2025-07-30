# Altagestion POS Modernization

This repository contains a legacy ASP application originally designed for Internet Explorer with `frameset` layout. Two new HTML5 entry pages are included to begin migrating towards modern browsers:

- `index.html` – Replaces `Index.htm` using `<iframe>` elements and Flexbox for layout.
- `login-frame.html` – Replaces `Index1.htm` and loads `Usuario.asp` inside a flexible container.

Both pages maintain the original frame structure using HTML5 and should work in Chrome or any modern browser.
They include Bootstrap 5 from `CSS/bootstrap.min.css` and `js/bootstrap.bundle.min.js` for consistent styling.
