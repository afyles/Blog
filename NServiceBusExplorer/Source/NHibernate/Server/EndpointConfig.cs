namespace Server
{
    using NHibernate;
    using NHibernate.Cfg;
    using NServiceBus;
    using log4net.Appender;
    using log4net.Core;

    public class EndpointConfig : IConfigureThisEndpoint, AsA_Server, IWantCustomInitialization
    {

        public void Init()
        {
            NServiceBus.Configure.With()
                .DefaultBuilder()
                .XmlSerializer()
                .UnicastBus()
                .MsmqSubscriptionStorage();

            ISessionFactory factory = this.ConfigureSessionFactory();

            Configure.Instance.Configurer.RegisterSingleton<ISessionFactory>(factory);

            Configure.Instance.Configurer.RegisterSingleton<IUnitOfWork>(new NHibernateUnitOfWork(factory));
        }

        public ISessionFactory ConfigureSessionFactory()
        {
            Configuration config = new Configuration();
            return config.Configure().BuildSessionFactory();
        }
    }
}
