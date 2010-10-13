namespace Client
{
    using System;
    using NServiceBus;
    using Messages;
    using Schedule;

    public class ClientEndpoint : IWantToRunAtStartup
    {
        public IBus Bus { get; set; }

        public void Run()
        {
            IBus bus = Configure.Instance.Builder.Build<IBus>();
            ISchedule<SendRequestDataMessage> schedule = new ServerBasedTimerSchedule<SendRequestDataMessage>(bus);
            schedule.Every(TimeSpan.FromSeconds(5), () => new SendRequestDataMessage());
            Configure.Instance.Configurer.RegisterSingleton<ISchedule<SendRequestDataMessage>>(schedule);

            Console.WriteLine("Press 'Enter' to send a message.To exit, Ctrl + C");

            //while (Console.ReadLine() != null)
            //{
            //    Guid g = Guid.NewGuid();

            //    Console.WriteLine("Requesting to get data by id: {0}", g.ToString("N"));

            //    Bus.OutgoingHeaders["Test"] = g.ToString("N");

            //    Bus.Send<IRequestDataMessage>(m =>
            //    {
            //        m.DataId = g;
            //        m.String = "<node>it's my \"node\" & i like it<node>";
            //    })
            //        .Register(i => Console.Out.WriteLine(
            //                           "Response with header 'Test' = {0}, 1 = {1}, 2 = {2}.",
            //                           Bus.CurrentMessageContext.Headers["Test"],
            //                           Bus.CurrentMessageContext.Headers["1"],
            //                           Bus.CurrentMessageContext.Headers["2"]));
            //}
        }

        public void Stop()
        {
        }
    }
}
