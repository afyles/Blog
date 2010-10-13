namespace BusServer
{
    using System;
    using System.Messaging;
    using log4net;
    using Messages;
    using NServiceBus;

    class PublisherEndpoint : IWantToRunAtStartup
    {
        private const String ClassName = "PublisherEndpoint";

        public IBus Bus { get; set; }

        #region IWantToRunAtStartup Members

        public void Run()
        {
            MessageQueue mq = null;

            String queueName = @".\private$\NServiceBus_InBound";

            if (MessageQueue.Exists(queueName))
                mq = new System.Messaging.MessageQueue(queueName);
            else
                mq = MessageQueue.Create(queueName);

            mq.Formatter = new BinaryMessageFormatter();

            while (true)
            {
                try
                {
                    System.Messaging.Message mes = mq.Receive(new TimeSpan(0, 0, 10));
                    mes.Formatter = new BinaryMessageFormatter();
                    IEvent eventMessage = mes.Body as IEvent;
                    this.Bus.Publish(eventMessage);
                    LogManager.GetLogger("Wbus").Info(string.Format("Published {0} event with Id {1}.", eventMessage.GetType().Name, eventMessage.EventId));
                }
                catch (System.Messaging.MessageQueueException mqe)
                {
                    LogManager.GetLogger(ClassName).Error(mqe.Message);
                    LogManager.GetLogger(ClassName).Info("Empty Queue");
                }
                catch (Exception ex)
                {
                    LogManager.GetLogger(ClassName).Error(ex.Message);
                }
            }
        }

        public void Stop()
        {
            
        }

        #endregion
    }
}
