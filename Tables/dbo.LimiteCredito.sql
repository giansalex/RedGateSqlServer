CREATE TABLE [dbo].[LimiteCredito]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_LC] [int] NOT NULL,
[Max] [decimal] (12, 3) NULL,
[Min] [decimal] (12, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LimiteCredito] ADD CONSTRAINT [PK_LimiteCredito] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Clt], [Id_LC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LimiteCredito] ADD CONSTRAINT [FK_LimiteCredito_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
