<html>
  <head>
    <style>
      p { page-break-after: always; }
      .footer { position: fixed; bottom: 0px; }
      .pagenum:before { content: counter(page); }
    </style>
  </head>
  <body>
    <div class="footer">Page: <span class="pagenum"></span></div>
    <p>lorem ipsum ...</p>
    <p>lorem ipsum ...</p>
  </body>
</html>