


String  emails_register(name)=>"""<!DOCTYPE html>
<html  >

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> <!-- Use the latest (edge) version of IE rendering engine -->
    <meta name="x-apple-disable-message-reformatting"> <!-- Disable auto-scale in iOS 10 Mail entirely -->
    <title>Biennvenue</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,500" rel="stylesheet">
    <!---bS link below --->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>

    <style>
        html,
        body {
            margin: 0 auto !important;
            padding: 0 !important;
            height: 100% !important;
            width: 100% !important;
        }

        /* What it does: Stops email clients resizing small text. */
        * {
            -ms-text-size-adjust: 100%;
            -webkit-text-size-adjust: 100%;
        }

        /* What it does: Centers email on Android 4.4 */
        div[style*="margin: 16px 0"] {
            margin: 0 !important;
        }

        /* What it does: Stops Outlook from adding extra spacing to tables. */
        table,
        td {
            mso-table-lspace: 0pt !important;
            mso-table-rspace: 0pt !important;
        }

        table {
            border-spacing: 0 !important;
            border-collapse: collapse !important;
            table-layout: fixed !important;
            margin: 0 auto !important;
			
        }

        table table table {
            table-layout: auto;
        }

        img {
            -ms-interpolation-mode: bicubic;
        }

        *[x-apple-data-detectors],
        /* iOS */
        .x-gmail-data-detectors,
        /* Gmail */
        .x-gmail-data-detectors *,
        .aBn {
            border-bottom: 0 !important;
            cursor: default !important;
            color: inherit !important;
            text-decoration: none !important;
            font-size: inherit !important;
            font-family: inherit !important;
            font-weight: inherit !important;
            line-height: inherit !important;
        }

        .a6S {
            display: none !important;
            opacity: 0.01 !important;
        }

        img.g-img+div {
            display: none !important;
        }

        /* What it does: Prevents underlining the button text in Windows 10 */
        .button-link {
            text-decoration: none !important;
        }

        @media only screen and (min-device-width: 375px) and (max-device-width: 413px) {
            .email-container {
                min-width: 375px !important;
            }
        }
    </style>
    <style>
        .button-td,
        .button-a {
            transition: all 100ms ease-in;
        }

        .button-td:hover,
        .button-a:hover {
            background: #555555 !important;
            border-color: #555555 !important;
        }

        /* Media Queries */
        @media screen and (max-width: 480px) {
            .fluid {
                width: 100% !important;
                max-width: 100% !important;
                height: auto !important;
                margin-left: auto !important;
                margin-right: auto !important;
            }

            .stack-column,
            .stack-column-center {
                display: block !important;
                width: 100% !important;
                max-width: 100% !important;
                direction: ltr !important;
            }

            /* And center justify these ones. */
            .stack-column-center {
                text-align: center !important;
            }

            .center-on-narrow {
                text-align: center !important;
                display: block !important;
                margin-left: auto !important;
                margin-right: auto !important;
                float: none !important;
            }

            table.center-on-narrow {
                display: inline-block !important;
            }

            .email-container p {
                font-size: 17px !important;
                line-height: 22px !important;
            }
        }
 .wc {
        background-color: #8dc441;
    }
    </style>
</head>

<body width="100%" bgcolor="#F1F1F1" style="margin: 0; mso-line-height-rule: exactly;">
<center style="width: 100%; background: #F1F1F1; text-align: left;">
    <div style="display:none;font-size:1px;line-height:1px;max-height:0px;max-width:0px;opacity:0;overflow:hidden;mso-hide:all;font-family: sans-serif;"> (Optional) This text will appear in the inbox preview, but not the email body. </div>
    <div style="max-width: 680px; margin: auto;" class="email-container">
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" align="center" width="100%" style="max-width: 680px;" class="email-container">
            <tr>
                <td bgcolor="white"  class="" >
                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td style="padding: 8px 8px 8px 8px; text-align: center;"> <img src="https://firebasestorage.googleapis.com/v0/b/sevenjobs-ea8a8.appspot.com/o/logo_round.png?alt=media&token=9ae33c28-d82a-46ae-8188-817bdb0a6b7c" alt="MY logo" width="60px" height="60px"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td  class="wc" align="center" valign="top" style="text-align: center; background-position: center center !important; background-size: cover !important;">
                    <div>
                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" align="center" width="100%" style="max-width:500px; margin: auto;">
                            <tr>
                                <td height="20" style="font-size:20px; line-height:20px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center" valign="middle">
                                    <table>
                                        <tr>
                                            <td valign="top" style="text-align: center; padding: 60px 0 10px 20px;">
                                                <h1 style="margin: 0; font-family: 'Montserrat', sans-serif; font-size: 30px; line-height: 36px; color: #ffffff; font-weight: bold;">Bienvenue ${name}!</h1>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="text-align: center; padding: 10px 20px 15px 20px; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #fff;">
                                                <p style="margin: 0;">Nous sommes ravis de vous accueillir dans la communauté SevenJobs ! L'équipe SevenJobs vous souhaite la bienvenue et vous remercie d'avoir choisi notre application mobile pour vous aider dans votre recherche d'emploi et pour vous connecter à de nouvelles opportunités passionnantes.</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" align="center" style="text-align: center; padding: 15px 0px 60px 0px;">
                                                <center>
                                                    <table role="presentation" align="center" cellspacing="0" cellpadding="0" border="0" class="center-on-narrow" style="text-align: center;">

                                                    </table>
                                                </center>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="20" style="font-size:20px; line-height:20px;">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td bgcolor="#ffffff">
                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td style="padding: 40px 40px 20px 40px; text-align: left;">
                                <h1 style="margin: 0; font-family: 'Montserrat', sans-serif; font-size: 20px; line-height: 26px; color: #333333; font-weight: bold;">VOTRE COMPTE EST MAINTENANT ACTIF</h1>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0px 40px 20px 40px; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555; text-align: left; font-weight:bold;">
                                <p style="margin: 0;">Merci d'avoir choisi notre application Seven JOBS</p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0px 40px 20px 40px; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555; text-align: left; font-weight:normal;">
                                <p style="margin: 0;">Votre compte a été créé avec succès et vous pouvez désormais accéder à notre plateforme pour explorer les offres d'emploi, télécharger votre CV, postuler à des emplois et bien plus encore. Nous sommes déterminés à vous fournir une expérience exceptionnelle tout au long de votre parcours professionnel.<br></p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr> <!-- INTRO : END -->
            <!-- CTA : BEGIN -->


            <tr>
                <td bgcolor="#26a4d3"  class="wc">
                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td style="padding: 40px 40px 5px 40px; text-align: center;">
                                <h1 style="margin: 0; font-family: 'Montserrat', sans-serif; font-size: 20px; line-height: 24px; color: #ffffff; font-weight: bold;">VOS RETOURS NOUS MOTIVENT À AVANCER</h1>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0px 40px 20px 40px; font-family: sans-serif; font-size: 17px; line-height: 23px; color: #aad4ea; text-align: center; font-weight:normal;">
                                <p style="margin: 0;">Faites-nous part de votre avis sur Seven Jobs</p>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="center" style="text-align: center; padding: 0px 20px 40px 20px;">
                                <!-- Button : BEGIN -->
                                <table role="presentation" align="center" cellspacing="0" cellpadding="0" border="0" class="center-on-narrow">
                                    <tr>
                                        <td style="border-radius: 50px; background: #ffffff; text-align: center;" class="button-td"> <a href="http://sevenjobs.fr/" style="background: #ffffff; border: 15px solid #ffffff; font-family: 'Montserrat', sans-serif; font-size: 14px; line-height: 1.1; text-align: center; text-decoration: none; display: block; border-radius: 50px; font-weight: bold;" class="button-a"> <span style="color:#26a4d3;" class="button-link">&nbsp;&nbsp;&nbsp;&nbsp;DONNEZ VOTRE AVIS&nbsp;&nbsp;&nbsp;&nbsp;</span> </a> </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td bgcolor="#ffffff">
                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%"> <br>
                        <tr>

                        </tr>
                        <tr>
                            <td align="center" style="font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 24px; padding: 5px 0 10px 0;">
                                <p style="font-size: 14px; font-weight: 800; line-height: 18px; color: #333333;"> Seven JOBS<br> </p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0px 40px 10px 40px; font-family: sans-serif; font-size: 12px; line-height: 18px; color: #666666; text-align: center; font-weight:normal;">
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 0px 40px 40px 40px; font-family: sans-serif; font-size: 12px; line-height: 18px; color: #666666; text-align: center; font-weight:normal;">

                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</center>
</body>

</html>""";