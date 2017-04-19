CREATE TABLE [dbo].[FabProcRel]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_PrcPre] [int] NOT NULL,
[ID_PrcPos] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabProcRel] ADD CONSTRAINT [PK_FabProcRel] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Flujo], [ID_PrcPre], [ID_PrcPos]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabProcRel] ADD CONSTRAINT [FK_FabProcRel_FabProceso] FOREIGN KEY ([RucE], [Cd_Flujo], [ID_PrcPre]) REFERENCES [dbo].[FabProceso] ([RucE], [Cd_Flujo], [ID_Prc])
GO
ALTER TABLE [dbo].[FabProcRel] ADD CONSTRAINT [FK_FabProcRel_FabProceso1] FOREIGN KEY ([RucE], [Cd_Flujo], [ID_PrcPos]) REFERENCES [dbo].[FabProceso] ([RucE], [Cd_Flujo], [ID_Prc])
GO
