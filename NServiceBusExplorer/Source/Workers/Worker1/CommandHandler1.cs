namespace Worker1
{
    using System;
    using NServiceBus;
    using Messages;
    using System.Threading;

    class CommandHandler1 : IHandleMessages<ICommand>
    {
        public IBus Bus { get; set; }

        #region IMessageHandler<ICommand> Members

        public void Handle(ICommand message)
        {
            Console.WriteLine("HANDLER 1: Received request {0}.", message.CommandId);
            Console.WriteLine("HANDLER 1: Command text received: {0}.", message.CommandText);
            Console.WriteLine("HANDLER 1: Header 'Test' = {0}.", message.GetHeader("Test"));

            if (message.CommandText.Equals("STOP EARLY", StringComparison.OrdinalIgnoreCase))
                this.Bus.DoNotContinueDispatchingCurrentMessageToHandlers();

            if (message.CommandText.Equals("CHANGE MESSAGE", StringComparison.OrdinalIgnoreCase))
                message.CommandText = "NEW MESSAGE TEXT";

            Thread.Sleep(new TimeSpan(0, 0, 1));
            /*
            var response = Bus.CreateInstance<ICommandResponse>(m =>
            {
                m.CommandId = message.CommandId;
                m.Success = true;
            });

            response.CopyHeaderFromRequest("Test");
            response.SetHeader("1", "1");
            response.SetHeader("2", "2");

            Bus.Reply(response); //You can try experimenting with sending multiple replies
             */
        }

        #endregion
    }
}
