namespace Profiles
{
    using log4net.Appender;
    using NServiceBus;

    public class IntegrationLoggingConfigurator : IConfigureLoggingForProfile<Integration>
    {
        public void Configure(IConfigureThisEndpoint specifier)
        {
            NServiceBus.SetLoggingLibrary.Log4Net<TraceAppender>(null,
               ta =>
               {
                   ta.ImmediateFlush = true;
               });
        }
    }

    public class ProductionLoggingConfigurator : IConfigureLoggingForProfile<Production>
    {
        public void Configure(IConfigureThisEndpoint specifier)
        {
            NServiceBus.SetLoggingLibrary.Log4Net<RollingFileAppender>(null,
                 rfa =>
                 {
                     rfa.File = "d:\\logs\\bus_server.log";
                 });
        }
    }
}
