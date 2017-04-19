CREATE TABLE [dbo].[CfgNivelAut]
(
[Id_Niv] [int] NOT NULL,
[Id_Aut] [int] NOT NULL,
[Niv] [int] NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AutComNiv] [bit] NOT NULL,
[IB_Hab] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgNivelAut] ADD CONSTRAINT [PK_CfgNivelAut] PRIMARY KEY CLUSTERED  ([Id_Niv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgNivelAut] ADD CONSTRAINT [IX_CfgNivelAut_IdAut_Niv] UNIQUE NONCLUSTERED  ([Id_Aut], [Niv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgNivelAut] WITH NOCHECK ADD CONSTRAINT [FK_CfgNivelAut_CfgAutorizacion] FOREIGN KEY ([Id_Aut]) REFERENCES [dbo].[CfgAutorizacion] ([Id_Aut]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Para los msjs de advertencia', 'SCHEMA', N'dbo', 'TABLE', N'CfgNivelAut', 'COLUMN', N'Descrip'
GO
