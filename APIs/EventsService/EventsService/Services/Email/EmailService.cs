using EventsService.Models;
using MailKit.Security;
using MimeKit.Text;
using MimeKit;
using MailKit.Net.Smtp;
using System.Text;
using EventsService.Services.Utility;

namespace EventsService.Services.Email
{
    public class EmailService : IEmailService
    {
        private readonly IConfiguration _config;
        private SportNetContext _context;


        public EmailService(IConfiguration config, SportNetContext context)
        {
            _config = config;
            _context = context;
        }

        private async Task<string> GenerateVerificationCode(int newLocationRequestId)
        {
            var verificationCode = SecurityHelper.GenerateNewLocationVerificationCode(6).Trim('=');
            var databaseStoredVerificationCode = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(verificationCode));

            var locationRequest = _context.RequestedLocations.First(x => x.Id == newLocationRequestId);

            locationRequest.Approved = true;

            var paymentRecord = (
                from payment in _context.PaymentDetails
                join locReq in _context.RequestedLocations
                on payment.RequestedLocationId equals locReq.Id
                where locReq.Id == newLocationRequestId
                select payment
            ).First();

            paymentRecord.VerificationCode = databaseStoredVerificationCode;

            await _context.SaveChangesAsync();

            return verificationCode;
        }

        private void SendEmail(string emailAddress, string verificationCode)
        {
            var email = new MimeMessage();
            email.From.Add(new MailboxAddress("Sport Net", _config.GetSection("EmailUsername").Value));
            email.To.Add(MailboxAddress.Parse(emailAddress));
            email.Subject = "Sport Net New Location Payment Verification Code";
            email.Body = new TextPart(TextFormat.Html) { Text = "\r\n<!doctype html>\r\n<html lang=\"en-US\">\r\n\r\n<head>\r\n    <meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" />\r\n    <title>Verification Code Template</title>\r\n    <meta name=\"description\" content=\"Verification Code Template.\">\r\n    <style type=\"text/css\">\r\n        a:hover {text-decoration: underline !important;}\r\n    </style>\r\n</head>\r\n\r\n<body marginheight=\"0\" topmargin=\"0\" marginwidth=\"0\" style=\"margin: 0px; background-color: #f2f3f8;\" leftmargin=\"0\">\r\n    <!--100% body table-->\r\n    <table cellspacing=\"0\" border=\"0\" cellpadding=\"0\" width=\"100%\" bgcolor=\"#f2f3f8\"\r\n        style=\"@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: 'Open Sans', sans-serif;\">\r\n        <tr>\r\n            <td>\r\n                <table style=\"background-color: #f2f3f8; max-width:670px;  margin:0 auto;\" width=\"100%\" border=\"0\"\r\n                    align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n                    <tr>\r\n                        <td style=\"height:80px;\">&nbsp;</td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td style=\"text-align:center;\">\r\n                          </a>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td style=\"height:20px;\">&nbsp;</td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td>\r\n                            <table width=\"95%\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\"\r\n                                style=\"max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);\">\r\n                                <tr>\r\n                                    <td style=\"height:40px;\">&nbsp;</td>\r\n                                </tr>\r\n                                <tr>\r\n                                    <td style=\"padding:0 35px;\">\r\n                                        <h1 style=\"color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;\">You have\r\n                                            requested us to add your new location</h1>\r\n                                        <span\r\n                                            style=\"display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;\"></span>\r\n                                        <p style=\"color:#455056; font-size:15px;line-height:24px; margin:0;\">\r\n                                            Our technical staff approved your location to be added for future use. A unique payment verification code to add your\r\n                                            location has been generated for you. In order to proceed, use it in our app.\r\n                                        </p>\r\n                                        <a href=\"\"\r\n                                            style=\"background:#22107B;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff; font-size:14px;padding:10px 24px;display:inline-block;border-radius:50px;\">" + verificationCode + "</a>\r\n                                    </td>\r\n                                </tr>\r\n                                <tr>\r\n                                    <td style=\"height:40px;\">&nbsp;</td>\r\n                                </tr>\r\n                            </table>\r\n                        </td>\r\n                    <tr>\r\n                        <td style=\"height:20px;\">&nbsp;</td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td style=\"text-align:center;\">\r\n                            <p style=\"font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;\">&copy; <strong>SportNet</strong></p>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td style=\"height:80px;\">&nbsp;</td>\r\n                    </tr>\r\n                </table>\r\n            </td>\r\n        </tr>\r\n    </table>\r\n    <!--/100% body table-->\r\n</body>\r\n\r\n</html>" };

            using var smtp = new SmtpClient();
            smtp.Connect(_config.GetSection("EmailHost").Value, 587, SecureSocketOptions.StartTls);
            smtp.Authenticate(_config.GetSection("EmailUsername").Value, _config.GetSection("EmailPassword").Value);
            var response = smtp.Send(email);
            smtp.Disconnect(true);
        }


        public async Task SendNewLocationApprovalVerificationCode(int newLocationRequestId)
        {
            var emailAddress = _context.RequestedLocations.First(x => x.Id == newLocationRequestId).OwnerEmail;
            var verifyCode = await GenerateVerificationCode(newLocationRequestId);

            SendEmail(emailAddress, verifyCode);
        }
    }
}
