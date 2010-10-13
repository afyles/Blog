namespace Profiles
{
    using System;
    using System.Diagnostics;
    using log4net;
    using NServiceBus;
    using NServiceBus.Host;
    using NServiceBus.Host.Internal;
    using NServiceBus.Unicast.Transport;

    public class Monitoring : IProfile { }
    public class InstallMonitoring : IProfile { }

    public class MonitoringProfileHandler : IHandleProfile<Monitoring>
    {
        private const String CategoryName = "NServiceBus Monitoring";
        private const String AvgProcessTimeCounterName = "Avg Message Processing Time";
        private const String AvgProcessTimeBaseCounterName = "Avg Message Processing Time Base";
        private const String FailedMessageProcesingCounterName = "Failures Per Second";

        #region IHandleProfile Members

        public void ProfileActivated()
        {
            this.MonitorAverageMessageProcessTime();
            this.MonitorFailedMessageProcessing();
        }

        #endregion

        private void MonitorAverageMessageProcessTime()
        {
            PerformanceCounter avgProcessTimeCounter = null;
            PerformanceCounter avgProcessTimeBaseCounter = null;
            Stopwatch watch = null;

            try
            {
                avgProcessTimeCounter = new PerformanceCounter(CategoryName, AvgProcessTimeCounterName, Program.EndpointId, false);
                avgProcessTimeBaseCounter = new PerformanceCounter(CategoryName, AvgProcessTimeBaseCounterName, Program.EndpointId, false);
            }
            catch (Exception e)
            {
                throw new InvalidOperationException("NServiceBus monitoring is not set up correctly. Running this process with the flag NServiceBus.InstallMonitoring should fix the problem.", e);
            }

            GenericHost.ConfigurationComplete +=
                (o, e) =>
                {
                    ITransport transport = Configure.Instance.Builder.Build<ITransport>();
                    transport.StartedMessageProcessing += (s, ea) => { watch = Stopwatch.StartNew(); };
                    transport.FinishedMessageProcessing +=
                        (s, ea) =>
                        {
                            watch.Stop();
                            avgProcessTimeCounter.IncrementBy(watch.ElapsedTicks);
                            avgProcessTimeBaseCounter.Increment();
                        };
                };
        }

        private void MonitorFailedMessageProcessing()
        {
            PerformanceCounter failedProcessingCounter = null;

            try
            {
                failedProcessingCounter = new PerformanceCounter(CategoryName, FailedMessageProcesingCounterName, Program.EndpointId, false);
            }
            catch (Exception e)
            {
                throw new InvalidOperationException("NServiceBus monitoring is not set up correctly. Running this process with the flag NServiceBus.InstallMonitoring should fix the problem.", e);
            }

            GenericHost.ConfigurationComplete +=
                (o, e) =>
                {
                    ITransport transport = Configure.Instance.Builder.Build<ITransport>();
                    transport.FailedMessageProcessing +=
                        (s, ea) =>
                        {
                            failedProcessingCounter.Increment();
                        };
                };
        }
    }

    public class InstallMonitoringHandler : IHandleProfile<InstallMonitoring>
    {
        private static readonly ILog Logger = LogManager.GetLogger("NServiceBus.Monitoring");
        private const String CategoryName = "NServiceBus Monitoring";
        private const String AvgProcessTimeCounterName = "Avg Message Processing Time";
        private const String AvgProcessTimeBaseCounterName = "Avg Message Processing Time Base";
        private const String FailedMessageProcesingCounterName = "Failures Per Second";

        #region IHandleProfile Members

        public void ProfileActivated()
        {
            Logger.Debug("Starting installation of  monitoring");

            if (PerformanceCounterCategory.Exists(CategoryName))
            {
                Logger.Warn(String.Format("Category {0} already exists, going to delete it first", CategoryName));
                PerformanceCounterCategory.Delete(CategoryName);
            }

            CounterCreationDataCollection counterData = new CounterCreationDataCollection();

            counterData.AddRange(this.InstallAverageMessageProcessTimeCounter());
            counterData.AddRange(this.InstalledFailedMessageProcessingCounter());

            PerformanceCounterCategory.Create(CategoryName, "NServiceBus Monitoring", PerformanceCounterCategoryType.MultiInstance, counterData);

        }

        #endregion

        private CounterCreationDataCollection InstalledFailedMessageProcessingCounter()
        {
            Logger.Debug("Starting installation of failed message processing monitoring");

            CounterCreationDataCollection counterData = new CounterCreationDataCollection();

            CounterCreationData totalFailures = new CounterCreationData(FailedMessageProcesingCounterName, 
                "Number of failed message processing attempts per second", 
                PerformanceCounterType.RateOfCountsPerSecond32);

            counterData.Add(totalFailures);

            Logger.Debug("Installation of failed message processing monitoring successful.");

            return counterData;
        }

        private CounterCreationDataCollection InstallAverageMessageProcessTimeCounter()
        {
            Logger.Debug("Starting installation of average process time monitoring");

            CounterCreationDataCollection counterData = new CounterCreationDataCollection();

            CounterCreationData avgTime = new CounterCreationData(AvgProcessTimeCounterName, 
                "Avg message processing time", 
                PerformanceCounterType.AverageTimer32);

            counterData.Add(avgTime);

            CounterCreationData avgBase = new CounterCreationData(AvgProcessTimeBaseCounterName, 
                "Avg message processing time base", 
                PerformanceCounterType.AverageBase);

            counterData.Add(avgBase);

            Logger.Debug("Installation of average processing time monitoring successful.");

            return counterData;
        }
    }
}
