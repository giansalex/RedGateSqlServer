CREATE TABLE [dbo].[FabObs]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Obs] [int] NOT NULL,
[ID_Eta] [int] NULL,
[FecObs] [datetime] NULL,
[Titulo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Resp] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Conclu] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Ruta] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabObs] ADD CONSTRAINT [PK_FabObs_1] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab], [ID_Obs]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabObs] WITH NOCHECK ADD CONSTRAINT [FK_FabObs_FabEtapa1] FOREIGN KEY ([RucE], [Cd_Fab], [ID_Eta]) REFERENCES [dbo].[FabEtapa] ([RucE], [Cd_Fab], [ID_Eta])
GO
ALTER TABLE [dbo].[FabObs] ADD CONSTRAINT [FK_FabObs_FabFabricacion] FOREIGN KEY ([RucE], [Cd_Fab]) REFERENCES [dbo].[FabFabricacion] ([RucE], [Cd_Fab])
GO
ALTER TABLE [dbo].[FabObs] NOCHECK CONSTRAINT [FK_FabObs_FabEtapa1]
GO
