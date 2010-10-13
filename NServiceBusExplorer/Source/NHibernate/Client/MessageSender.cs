namespace Client
{
    using System;
    using Messages;
    using NServiceBus;

    public class MessageSender : IWantToRunAtStartup
    {
        public IBus Bus { get; set; }

        public void Run()
        {
            Console.WriteLine("Press 'Enter' to send a message.To exit, Ctrl + C");

            while (Console.ReadLine() != null)
            {
                Bus.Send<ProductCreatedMessage>(m =>
                {
                    m.Description = "HELLO";
                    m.Name = "HELLO";
                    m.ProductNumber = 11111;
                });
            }
        }

        public void Stop()
        {
        }
    }
}
