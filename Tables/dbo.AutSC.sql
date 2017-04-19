CREATE TABLE [dbo].[AutSC]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecAut] [datetime] NOT NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutSC] WITH NOCHECK ADD CONSTRAINT [FK_AutSC_SolicitudCom] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom] ([RucE], [Cd_SCo]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'SC00000001', 'SCHEMA', N'dbo', 'TABLE', N'AutSC', 'COLUMN', N'Cd_SCo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutSC', 'COLUMN', N'NomUsu'
GO
