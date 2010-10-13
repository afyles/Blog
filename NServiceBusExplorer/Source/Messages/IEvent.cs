using NServiceBus;
using System;

namespace Messages
{

    public interface IEvent : IMessage
    {
        Guid EventId { get; set; }
        DateTime Time { get; set; }
        TimeSpan Duration { get; set; }
    }
}
