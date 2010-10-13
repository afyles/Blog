namespace Messages
{
    using NServiceBus;
    using System;

    public interface ICommandResponse : IMessage
    {
        Guid CommandId { get; set; }
        DateTime Time { get; set; }
        TimeSpan Duration { get; set; }
        Boolean Success { get; set; }
    }
}
