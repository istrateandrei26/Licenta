using Microsoft.Extensions.Primitives;

namespace EventsService.DTOs.Request
{
    public class ConfirmNewLocationPaymentRequest
    {
        public int ApprovedLocationId { get; set; }
    }
}
