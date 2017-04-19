CREATE TABLE [dbo].[AlertXUsu]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TA] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_NoRecordar] [bit] NOT NULL,
[IB_RecProxIni] [bit] NOT NULL,
[IB_RecCada] [bit] NOT NULL,
[IB_RecDentro] [bit] NOT NULL,
[RecordarCada] [int] NULL,
[RecordarDentro] [int] NULL,
[CampoConfg] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlertXUsu] ADD CONSTRAINT [PK_AlertXUsu] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TA], [NomUsu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlertXUsu] ADD CONSTRAINT [FK_AlertXUsu_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[AlertXUsu] ADD CONSTRAINT [FK_AlertXUsu_TipAlert] FOREIGN KEY ([Cd_TA]) REFERENCES [dbo].[TipAlert] ([Cd_TA])
GO
ALTER TABLE [dbo].[AlertXUsu] ADD CONSTRAINT [FK_AlertXUsu_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se utiliza para días en alertas de tipo Contrato', 'SCHEMA', N'dbo', 'TABLE', N'AlertXUsu', 'COLUMN', N'CampoConfg'
GO
