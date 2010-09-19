using System;

namespace Messages
{
    public interface IOrderAcceptedEvent : IEvent
    {
        Int32 OrderId { get; set; }
    }
}
