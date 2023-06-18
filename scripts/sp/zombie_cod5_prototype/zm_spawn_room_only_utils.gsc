get_nodes(root_ent)
{
    nodes = [];
    node = root_ent;

    for (i = 0; isDefined(node); i++)
    {
        nodes[i] = node;
        if (isDefined(node.target))
        {
            node = GetEnt(node.target, "targetname");
        }
        else
        {
            node = undefined;
        }
    }

    return nodes;
}

is_facing(facee, dot_limit)
{
    orientation = self GetPlayerAngles();
    forwardVec = AnglesToForward(orientation);
    forwardVec2D = (forwardVec[0], forwardVec[1], 0);
    unitForwardVec2D = VectorNormalize(forwardVec2D);

    toFaceeVec = facee.origin - self.origin;
    toFaceeVec2D = (toFaceeVec[0], toFaceeVec[1], 0);
    unitToFaceeVec2D = VectorNormalize(toFaceeVec2D);

    dotProduct = VectorDot(unitForwardVec2D, unitToFaceeVec2D);

    return (dotProduct > dot_limit);
}

six_feet_under()
{
    self.initial_origin = self.origin;
    self.origin += (0, 0, -10000);
}

do_nothing()
{

}
