namespace Server
{
    using NServiceBus;
    using Messages;
    using System;
    using NServiceBus.Host;
    using System.Diagnostics;

    public class RequestHandler : IHandleMessages<IRequestDataMessage>
    {
        public IBus Bus { get; set; }

        public void Handle(IRequestDataMessage message)
        {
            Console.WriteLine("Received request {0}.", message.DataId);
            Console.WriteLine("String received: {0}.", message.String);
            Console.WriteLine("Header 'Test' = {0}.", message.GetHeader("Test"));

            var response = Bus.CreateInstance<IDataResponseMessage>(m =>
            {
                m.DataId = message.DataId;
                m.String = message.String;
            });

            response.CopyHeaderFromRequest("Test");
            response.SetHeader("1", "1");
            response.SetHeader("2", "2");

            Bus.Reply(response); 
        }
    }

    public abstract class RequestHandlerBase<T> : IMessageHandler<T> where T : IMessage
    {
        PerformanceCounter avgProcessTimeCounter = null;
        PerformanceCounter avgProcessTimeBaseCounter = null;
        System.Diagnostics.Stopwatch watch = null;
        readonly String counterName;
        readonly String categoryName;

        public RequestHandlerBase(String categoryName, String counterName)
        {
            this.categoryName = categoryName;
            this.counterName = counterName;
        }

        public Boolean MeasurePerformance { get; set; }

        public abstract void HandleMessage(T message);

        public void Handle(T message)
        {
            try
            {
                avgProcessTimeCounter = new PerformanceCounter(categoryName, counterName, Program.EndpointId, false);
                avgProcessTimeBaseCounter = new PerformanceCounter(categoryName, String.Concat(counterName,"Base"), Program.EndpointId, false);
                
                watch = Stopwatch.StartNew();

                this.HandleMessage(message);

                watch.Stop();
                avgProcessTimeCounter.IncrementBy(watch.ElapsedTicks);
                avgProcessTimeBaseCounter.Increment();
            }
            catch( InvalidOperationException )
            {
            }
        }
    }
}
