#!/usr/bin/env python
# move container to new workspace (lowsest available number)
# go to the new workspace
from i3ipc import Connection


def lowest_workspace_index(workspaces):
    # Sort workspaces by index number
    workspaces = sorted(workspaces, key=lambda x: x.num)

    lowest_index = 1
    for workspace in workspaces:
        if workspace.num > lowest_index:
            return lowest_index
        elif workspace.num == lowest_index:
            lowest_index += 1

    return lowest_index


if __name__ == "__main__":
    i3 = Connection()
    workspaces = i3.get_workspaces()

    new_workspace_index = lowest_workspace_index(workspaces)
    print(new_workspace_index)
    i3.command(
        f"move container to workspace number {new_workspace_index};"
        f"workspace number {new_workspace_index}"
    )
