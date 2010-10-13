namespace Client
{
    using System;
    using NServiceBus;
    using Messages;

    public class SendRequestHandler : IHandleMessages<SendRequestDataMessage>
    {
        public IBus Bus { get; set; }

        public void Handle(SendRequestDataMessage message)
        {
            Guid g = Guid.NewGuid();

            Console.WriteLine("REQUESTING to get data by id: {0} ****************************", g.ToString("N"));

            this.Bus.OutgoingHeaders["Test"] = g.ToString("N");

            this.Bus.Send<IRequestDataMessage>(m =>
            {
                m.DataId = g;
                m.String = "<node>it's my \"node\" & i like it<node>";
            })
                .Register(i => Console.Out.WriteLine(
                                   "Response with header 'Test' = {0}, 1 = {1}, 2 = {2}.",
                                   Bus.CurrentMessageContext.Headers["Test"],
                                   Bus.CurrentMessageContext.Headers["1"],
                                   Bus.CurrentMessageContext.Headers["2"]));
        }
    }
}
