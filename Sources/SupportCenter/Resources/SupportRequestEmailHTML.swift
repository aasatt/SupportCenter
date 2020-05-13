//
//  SupportRequestEmailHTML.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation

func createSupportHTML(with message: String, metadata: Metadata?) -> String {
    var html = TemplateHTML
    html = html.replacingOccurrences(of: "{{message.body}}", with: message)
    html = html.replacingOccurrences(of: "{{metadata.appversion}}", with: metadata?.appVersion ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.device}}", with: metadata?.device ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.os}}", with: metadata?.os ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.presentingController}}", with: metadata?.presentingController ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.locale}}", with: metadata?.locale ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.languages}}", with: metadata?.languages ?? "---")
    html = html.replacingOccurrences(of: "{{metadata.bundleId}}", with: metadata?.bundleId ?? "---")
    return html
}

private let TemplateHTML = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html data-editor-version="2" class="sg-campaigns" xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=Edge">
      <!--<![endif]-->
      <!--[if (gte mso 9)|(IE)]>
      <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
      </xml>
      <![endif]-->
      <!--[if (gte mso 9)|(IE)]>
  <style type="text/css">
    body {width: 600px;margin: 0 auto;}
    table {border-collapse: collapse;}
    table, td {mso-table-lspace: 0pt;mso-table-rspace: 0pt;}
    img {-ms-interpolation-mode: bicubic;}
  </style>
<![endif]-->
      <style type="text/css">
    body, p, div {
      font-family: arial,helvetica,sans-serif;
      font-size: 14px;
    }
    body {
      color: #000000;
    }
    body a {
      color: #1188E6;
      text-decoration: none;
    }
    p { margin: 0; padding: 0; }
    table.wrapper {
      width:100% !important;
      table-layout: fixed;
      -webkit-font-smoothing: antialiased;
      -webkit-text-size-adjust: 100%;
      -moz-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }
    img.max-width {
      max-width: 100% !important;
    }
    .column.of-2 {
      width: 50%;
    }
    .column.of-3 {
      width: 33.333%;
    }
    .column.of-4 {
      width: 25%;
    }
    @media screen and (max-width:480px) {
      .preheader .rightColumnContent,
      .footer .rightColumnContent {
        text-align: left !important;
      }
      .preheader .rightColumnContent div,
      .preheader .rightColumnContent span,
      .footer .rightColumnContent div,
      .footer .rightColumnContent span {
        text-align: left !important;
      }
      .preheader .rightColumnContent,
      .preheader .leftColumnContent {
        font-size: 80% !important;
        padding: 5px 0;
      }
      table.wrapper-mobile {
        width: 100% !important;
        table-layout: fixed;
      }
      img.max-width {
        height: auto !important;
        max-width: 100% !important;
      }
      a.bulletproof-button {
        display: block !important;
        width: auto !important;
        font-size: 80%;
        padding-left: 0 !important;
        padding-right: 0 !important;
      }
      .columns {
        width: 100% !important;
      }
      .column {
        display: block !important;
        width: 100% !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
        margin-left: 0 !important;
        margin-right: 0 !important;
      }
      .social-icon-column {
        display: inline-block !important;
      }
    }
  </style>
      <!--user entered Head Start--><!--End Head user entered-->
    </head>
    <body>
      <center class="wrapper" data-link-color="#1188E6" data-body-style="font-size:14px; color:#000000; background-color:#FFFFFF; font-family:arial,helvetica,sans-serif;">
        <div class="webkit">
          <table cellpadding="0" cellspacing="0" border="0" width="100%" class="wrapper" bgcolor="#FFFFFF">
            <tr>
              <td valign="top" bgcolor="#FFFFFF" width="100%">
                <table width="100%" role="content-container" class="outer" align="center" cellpadding="0" cellspacing="0" border="0">
                  <tr>
                    <td width="100%">
                      <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                          <td>
                            <!--[if mso]>
    <center>
    <table><tr><td width="600">
  <![endif]-->
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="width:100%; max-width:600px;" align="center">
                                      <tr>
                                        <td role="modules-container" style="padding:0px 0px 0px 0px; color:#000000; text-align:left;" bgcolor="#FFFFFF" width="100%" align="left"><table class="module preheader preheader-hide" role="module" data-type="preheader" border="0" cellpadding="0" cellspacing="0" width="100%" style="display: none !important; mso-hide: all; visibility: hidden; opacity: 0; color: transparent; height: 0; width: 0;">
    <tr>
      <td role="module-content">
        <p></p>
      </td>
    </tr>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="14457b5e-6b56-4b80-9a1c-a1b318362e9f" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="padding:18px 0px 18px 0px; line-height:22px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{message.body}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="divider" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="f4f584bb-c207-43ba-91b9-cc6a00c2d673">
    <tbody>
      <tr>
        <td style="padding:0px 0px 0px 0px;" role="module-content" height="100%" valign="top" bgcolor="">
          <table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" height="2px" style="line-height:2px; font-size:2px;">
            <tbody>
              <tr>
                <td style="padding:0px 0px 2px 0px;" bgcolor="#bdbdbd"></td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:0px 0px 0px 0px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top"><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 10px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-0">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>APP VERSION</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; line-height:22px; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.appversion}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 10px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-1">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>DEVICE</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.device}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:0px 0px 0px 0px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top"><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 10px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-0">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.2" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>OS</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.2" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.os}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 10px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-1">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>CURRENT VIEW</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.presentingController}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:0px 0px 0px 0px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top"><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 10px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-0">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.2.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>LOCALE</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.2.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.locale}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 10px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-1">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.1.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>LANGUAGES</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.1.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.languages}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:0px 0px 0px 0px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top"><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 10px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-0">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="fc073921-1e45-4b98-bea7-7646535eb0e7.1.1.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="text-align:inherit; padding:0px 0px 0px 0px; line-height:20px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 10px"><strong>BUNDLE ID</strong></span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9a7cee71-2031-4f8d-ad93-4ab0acae06e0.1.1.1.1" data-mc-module-version="2019-10-22">
    <tbody>
      <tr>
        <td style="line-height:22px; text-align:inherit; padding:0px 0px 0px 0px;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">{{metadata.bundleId}}</div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table><table width="290" style="width:290px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 10px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-1">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table></td>
                                      </tr>
                                    </table>
                                    <!--[if mso]>
                                  </td>
                                </tr>
                              </table>
                            </center>
                            <![endif]-->
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </div>
      </center>
    </body>
  </html>
"""
