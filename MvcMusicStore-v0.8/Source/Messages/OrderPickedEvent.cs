using System;

namespace Messages
{
    public interface IOrderPickedEvent : IEvent
    {
        Int32 ShippingNoteId { get; set; }
        Int32 OrderId { get; set; }
    }
}
