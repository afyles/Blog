using System;
using NServiceBus;

namespace Messages
{
    public interface IAuthorizePaymentEvent : IEvent
    {
        Int32 OrderId { get; set; }
        Boolean Authorized { get; set; }
    }
}
