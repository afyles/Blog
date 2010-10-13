namespace DistributorClient
{
    using NServiceBus;
    using System;
    using Messages;

    public class ClientEndpoint : IWantToRunAtStartup
    {
        public IBus Bus { get; set; }

        #region IWantToRunAtStartup Members

        public void Run()
        {
            Console.WriteLine("Enter a message then press 'Enter' to send a message.To exit, Ctrl + C");

            String commandText = String.Empty;

            while ((commandText = Console.ReadLine()) != null)
            {
                Guid g = Guid.NewGuid();

                Console.WriteLine("Sending command with id {0} and command {1}", g.ToString("N"), commandText);

                Bus.OutgoingHeaders["Test"] = g.ToString("N");

                Bus.Send<ICommand>(m =>
                {
                    m.CommandId = g;
                    m.CommandText = commandText;
                });
                /*  
                .Register(i => Console.Out.WriteLine(
                                       "Response with header 'Test' = {0}, 1 = {1}, 2 = {2}.",
                                       Bus.CurrentMessageContext.Headers["Test"],
                                       Bus.CurrentMessageContext.Headers["1"],
                                       Bus.CurrentMessageContext.Headers["2"]));
                 */
            }
        }

        public void Stop()
        {
        }

        #endregion
    }
}
