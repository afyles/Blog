namespace Messages
{
    using NServiceBus;
    using System;

    public interface ICommand : IMessage
    {
        Guid CommandId { get; set; }
        DateTime Time { get; set; }
        TimeSpan Duration { get; set; }
        String CommandText { get; set; }
    }
}
